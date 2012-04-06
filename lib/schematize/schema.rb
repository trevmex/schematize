require 'rubygems'
require 'rest-client'
require 'nokogiri'
require 'active_support/core_ext/object/blank'
require File.absolute_path(File.join(File.dirname(__FILE__), 'data_type'))


module Schematize
  class Schema
    attr_reader :type, :package, :url, :data_itemtype_url, :imports

    @@type_cache = {}
    
    def self.property_chain(this_type, p_chain)
      p_chain = this_type.properties.blank? ? p_chain : p_chain.merge(this_type.properties)
      
      if this_type.parent.blank?
        return p_chain
      end
      
      property_chain(self.new(this_type.parent, this_type.package), p_chain)
    end

    def self.types
      url = 'http://schema.org/docs/full.html'
      html = RestClient.get(url)
      dom = Nokogiri::HTML(html) unless html.code != 200
      dom.css('.faq > table.h')[1].css('td.tc a').map do |type|
        type.text[-1] == "*" ? type.text[0..-2] : type.text
      end
    end
    
    def get(param, valueToEval="")
      @@type_cache[@type] = {} if @@type_cache[@type].blank?
      return @@type_cache[@type][param] unless @@type_cache[@type][param].blank?
      @@type_cache[@type][param] = eval(valueToEval)
    end
    
    def initialize(type, package="")
      @type = type
      @package = package
      @url = get(:url, '"http://schema.org/#{@type}"')
      
      
      @data_itemtype_url = get(:data_itemtype_url, 'nil')
      @imports = get(:imports, '[]')

      @html = get(:html, 'RestClient.get(@url)')
      @dom = get(:dom, '(Nokogiri::HTML(@html) unless @html.code != 200)')
    end

    def parent
      @parent ||= get(:parent, '@dom.css(".page-title a").map do |klass|
        klass.text.strip
      end[-2]')
    end

    def properties
      @properties ||= get(:properties, '(@dom.css("table.definition-table tbody.supertype")[-1].css("tr").reduce({}) do |hash, row|
        property_name = property_name(row)
        hash[property_name] = property_info(row) unless property_name.blank?
        hash
      end if has_properties?)')
    end
    
    private
    
    def has_properties?
      type_header = @dom.css('table.definition-table thead.supertype')
      return nil unless type_header[-1]
      type_header[-1].css('th a').text == @type
    end

    def property_name(row)
      row.css('.prop-nam code').text.strip.to_sym
    end

    def is_set?(name)
      [:description, :encodesCreativeWork, :video, :offers].include? name
    end

    def property_info(row)
      types = row.css('.prop-ect').text.strip.split(/\sor\s/).map { |type| type.strip }
      specific_types = types.join(' or ') unless types.size < 2
      is_set = is_set?(property_name(row))
      type = property_type(types, {:is_set => is_set})
      result = { :type => type }
      result[:specific_types] = specific_types unless specific_types.blank?
      
      if DataType.needs_import?(type)
        fully_qualified_java_class = DataType.fully_qualified_java_class(type)
        if fully_qualified_java_class.blank?
          result[:import] = "#{@package}.#{type}"
        else
          result[:import] = fully_qualified_java_class
          @imports.push(fully_qualified_java_class)
        end
      end

      result
    end
    
    def property_type(types, options = {:is_set => false})
      raise ArgumentError, 'types must be mappable' unless types.respond_to? :map
      return DataType.to_java(types[0].to_sym, options) unless types.size > 1
      return DataType.to_java(:Text, options) if types.include?('Text') # For 'Text or URL'
      
      property_type(types.map do |type|
        type == 'Thing' ? 'Thing' : self.class.new(type).parent # Thing is the top type, stop there.
      end.uniq, options)
    end
  end
end
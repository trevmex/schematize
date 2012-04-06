require 'rubygems'
require 'erb'
require 'active_support/core_ext/object/blank'
require 'active_support/core_ext/string/inflections'
require File.absolute_path(File.join(File.dirname(__FILE__), 'util'))

module Schematize
  class Parser
    attr_reader :directory
    
    def initialize(schema, options={:output_dir => File.absolute_path(File.join(File.dirname(__FILE__), '..', 'output')), :template_file_name => 'Schema.java.erb', :language => 'java', :test => false, :impl => false})
      @schema = schema
      
      @language = options[:language].blank? ? options[:language] : options[:template_file_name].split('.')[1]
      @template_file = File.read(File.join(File.dirname(__FILE__), '..', 'templates', options[:template_file_name]))
      @template = ERB.new(@template_file)
      @test = options[:test]
      @impl = options[:impl]
      
      @parsed_template = @template.result(binding)
      
      @directory = File.join(options[:output_dir], 'src', @test ? 'test' : 'main', @language, @schema.package.split('.'))
      @directory = File.join(@directory, 'impl') if @impl
    end
    
    def write_to_file
      Util.write_to_file("#{"Immutable" if @impl}#{@schema.type}#{"Test" if @test}.#{@language}", @directory, @parsed_template)
    end
  end
end
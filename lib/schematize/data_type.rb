require 'active_support/core_ext/object/blank'

module Schematize
  class DataType
    def self.native_java_class?(type)
      return false if type.blank? || !type.respond_to?(:to_sym)
      [:String, :Number, :Integer, :Float, :URL, :DateTime, :Duration, :Boolean].include? type.to_sym
    end
    
    def self.needs_import?(type)
      return false if type.blank? || !type.respond_to?(:to_sym)
      !([:String, :Number, :Integer, :Float, :Boolean].include?(type.to_sym))
    end
    
    def self.fully_qualified_java_class(type)
      # Most Schema.org data types map directly to Java classes
      # This mapping is for those that do not.
      java_mappings = {
        :Date => :"org.joda.time.DateTime",
        :Duration => :"org.joda.time.Duration",
        :URL => :"java.net.URL"
      }

      java_mappings[type].blank? ? nil : java_mappings[type]
    end
    
    def self.to_java(type, options = {:is_set => false})
      # Most Schema.org data types map directly to Java classes
      # This mapping is for those that do not.
      java_mappings = {
        :Date => :DateTime,
        :Text => :String
      }

      type = java_mappings[type].blank? ? type : java_mappings[type]
      type = "Set<#{type}>" if options[:is_set]
      type
    end
  end
end
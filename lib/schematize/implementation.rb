require File.absolute_path(File.join(File.dirname(__FILE__), 'parser'))

module Schematize
  class Implementation
    def initialize(schema, options={:output_dir => File.absolute_path(File.join(File.dirname(__FILE__), '..', 'output'))})
      @implementation = SchemaMapper::Parser.new(schema, {:output_dir => options[:output_dir], :template_file_name => 'ImmutableSchema.java.erb', :language => 'java', :test => false, :impl => true})
    end

    def write_to_file
      @implementation.write_to_file
    end

    def directory
      @implementation.directory
    end
  end
end
require File.absolute_path(File.join(File.dirname(__FILE__), 'parser'))

module Schematize
  class ImplementationTest
    def initialize(schema, options={:output_dir => File.absolute_path(File.join(File.dirname(__FILE__), '..', 'output'))})
      @implementation_test = SchemaMapper::Parser.new(schema, {:output_dir => options[:output_dir], :template_file_name => 'ImmutableSchemaTest.java.erb', :language => 'java', :test => true, :impl => true})
    end

    def write_to_file
      @implementation_test.write_to_file
    end

    def directory
      @implementation_test.directory
    end
  end
end
require File.absolute_path(File.join(File.dirname(__FILE__), 'schematize', 'mapper'))

module Schematize
  def self.map(files=[:interface, :implementation, :implementation_test], options={:package => "", :output_dir => File.absolute_path(File.join(File.dirname(__FILE__), 'output'))})
    Mapper.generate(files, options)
  end
end
require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Schematize do
  describe ".map" do
    it "calls the map generator with the correct parameters" do
      Schematize::Mapper.should_receive(:generate).with("file.test", {:package => "com.example", :output_dir => "."})
      Schematize.map("file.test", {:package => "com.example", :output_dir => "."})
    end
  end
end

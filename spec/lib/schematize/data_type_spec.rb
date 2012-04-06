require File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 'spec_helper'))

describe Schematize do
  describe "DataType" do
    describe ".native_java_class?" do
      it "returns true for native java class types" do
        Schematize::DataType.native_java_class?(:String).should be_true
        Schematize::DataType.native_java_class?(:Number).should be_true
        Schematize::DataType.native_java_class?(:Integer).should be_true
        Schematize::DataType.native_java_class?(:Float).should be_true
        Schematize::DataType.native_java_class?(:URL).should be_true
        Schematize::DataType.native_java_class?(:DateTime).should be_true
        Schematize::DataType.native_java_class?(:Duration).should be_true
        Schematize::DataType.native_java_class?(:Boolean).should be_true
      end

      it "returns false for any other symbol" do
        Schematize::DataType.native_java_class?(:Thing).should be_false
      end

      it "returns correct results for string representations" do
        Schematize::DataType.native_java_class?("String").should be_true
        Schematize::DataType.native_java_class?("Thing").should be_false
      end

      it "returns false for anything not a symbol or string" do
        Schematize::DataType.native_java_class?(nil).should be_false
        Schematize::DataType.native_java_class?(123).should be_false
        Schematize::DataType.native_java_class?(123.45).should be_false
      end
    end

    describe ".needs_import?" do
      it "returns true if an import is needed" do
        Schematize::DataType.needs_import?(:URL).should be_true
        Schematize::DataType.needs_import?(:DateTime).should be_true
        Schematize::DataType.needs_import?(:Duration).should be_true
      end

      it "returns false if an import is not needed" do
        Schematize::DataType.needs_import?(:String).should be_false
        Schematize::DataType.needs_import?(:Number).should be_false
        Schematize::DataType.needs_import?(:Integer).should be_false
        Schematize::DataType.needs_import?(:Float).should be_false
        Schematize::DataType.needs_import?(:Boolean).should be_false
      end

      it "returns correct results for string representations" do
        Schematize::DataType.needs_import?("URL").should be_true
        Schematize::DataType.needs_import?("String").should be_false
      end

      it "returns false for anything not a symbol or string" do
        Schematize::DataType.needs_import?(nil).should be_false
        Schematize::DataType.needs_import?(123).should be_false
        Schematize::DataType.needs_import?(123.45).should be_false
      end
    end

    describe ".fully_qualified_java_class" do
      it "returns nil for classes that map directly to Java Classes" do
        Schematize::DataType.fully_qualified_java_class(:String).should be_nil
        Schematize::DataType.fully_qualified_java_class(:Thing).should be_nil
      end

      it "returns DateTime class name" do
        Schematize::DataType.fully_qualified_java_class(:Date).should equal :"org.joda.time.DateTime"
      end

      it "returns Duration class name" do
        Schematize::DataType.fully_qualified_java_class(:Duration).should equal :"org.joda.time.Duration"
      end

      it "returns URL class name" do
        Schematize::DataType.fully_qualified_java_class(:URL).should equal :"java.net.URL"
      end

      it "returns correct results for string representations" do
        Schematize::DataType.fully_qualified_java_class("URL").should equal :"java.net.URL"
        Schematize::DataType.fully_qualified_java_class("String").should be_nil
      end
    end
  end
end

module Schematize
  class Util
    def self.write_to_file(file_name, dir, content)
      FileUtils.mkdir_p(dir)
      File.open(File.join(dir, file_name), 'w') do |file|
        file.write(content)
      end
    end
  end
end
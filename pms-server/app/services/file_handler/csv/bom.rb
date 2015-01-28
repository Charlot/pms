module FileHandler
  module Csv
    class Bom
      def self.import(file)
        puts '---------------------------------------------'
        puts file.to_json
        puts '---------------------------------------------'
      end
    end
  end
end
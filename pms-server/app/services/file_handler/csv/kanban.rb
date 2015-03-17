require 'csv'
module FileHandler
  module Csv
    class Kanban<Base
      IMPORT_HEADERS=['Quantity','Safety Stock','Copies','Remark',
                      'Wire Nr','Product Nr','Type','Product','Wire Length','Bundle',
      'Source Warehouse','Source Storage','Destination Warehouse','Destination Storage']
      INVALID_CSV_HEADERS=IMPORT_HEADERS<<'Error MSG'

      def self.import(file)

      end

      def self.validate_row(row)
        #TODO Validate kanban
      end
    end
  end
end
require 'csv'
module FileHandler
  module Csv
    class KanbanHandler<Base
      IMPORT_HEADERS=['Quantity','Safety Stock','Copies','Remark',
                      'Wire Nr','Product Nr','Type','Product','Wire Length','Bundle',
      'Source Warehouse','Source Storage','Destination Warehouse','Destination Storage']
      INVALID_CSV_HEADERS=IMPORT_HEADERS<<'Error MSG'

      def self.import(file)

      end

      def self.validate_import(file)
        tmp_file=full_tmp_path(file.file_name)
        msg=Message.new(result: true)
        CSV.open(tmp_file, 'wb', write_headers: true,
                 headers: INVALID_CSV_HEADERS, col_sep: file.col_sep, encoding: file.encoding) do |csv|
          CSV.foreach(file.file_path, headers: file.headers, col_sep: file.col_sep, encoding: file.encoding) do |row|
            puts "validate row"
            if mmsg.result
              csv<<row.fields
            else
              if msg.result
                msg.result=false
                msg.content = "请下载错误文件<a href='/files/#{Base64.urlsafe_encode64(tmp_file)}'>#{::File.basename(tmp_file)}</a>"
              end
              csv<<(row.fields<<mmsg.content)
            end
          end
        end
        return msg
      end

      def self.validate_row(row)
        #TODO Validate kanban
      end
    end
  end
end
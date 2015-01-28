module FileHandler
  module Csv
    class Bom
      IMPORT_HEADERS=['Part Nr', 'Component Nr', 'Quantity']

      # import bom by file
      def self.import(file)
        msg=Message.new
        begin
          line_no = 0
          CSV.foreach(file.file_path, headers: file.headers, col_sep: file.col_sep, encoding: file.encoding) do |row|
            row.strip
            line_no+=1
          end
          msg.result=true
          msg.content='Bom 上传成功！'
        rescue => e
          msg.content = e.message
        end
        return msg
      end

      def self.validate_import(file)
        msg=ValidateMessage.new

      end
    end
  end
end
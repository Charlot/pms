module FileHandler
  module Csv
    class Bom
      IMPORT_HEADERS=['Part Nr', 'Component Nr', 'Quantity']

      def self.import(file)
        msg=Message.new
        begin
          line_no = 0
          CSV.foreach(file.file_path, headers: file.headers, col_sep: file.col_sep, encoding: file.encoding) do |row|
            row.strip
            line_no+=1
          end
        rescue => e
          msg.content = e.message
        end
        return msg
      end
    end
  end
end
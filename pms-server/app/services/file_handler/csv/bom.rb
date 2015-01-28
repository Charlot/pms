require 'csv'
module FileHandler
  module Csv
    class Bom<Base
      IMPORT_HEADERS=['Part Nr', 'Component Nr', 'Quantity']
      INVALID_CSV_HEADERS=IMPORT_HEADERS<<'Error MSG'
      # import bom by file
      def self.import(file)
        msg=Message.new
        begin
          validate_msg=validate_import(file)
          if validate_msg.result
            line_no = 0
            CSV.foreach(file.file_path, headers: file.headers, col_sep: file.col_sep, encoding: file.encoding) do |row|
              line_no+=1
              row<<'JACK'
            end
            msg.result=true
            msg.content='Bom 上传成功！'
          else
            msg.result =false
            msg.content=validate_msg.content
          end
        rescue => e
          puts e.backtrace
          msg.content = e.message
        end
        puts msg.to_json
        return msg
      end

      def self.validate_import(file)
        tmp_file=full_tmp_path(file.file_name)
        msg=Message.new
        CSV.open(tmp_file, 'wb', write_headers: true,
                 headers: INVALID_CSV_HEADERS, col_sep: file.col_sep, encoding: file.encoding) do |csv|
          CSV.foreach(file.file_path, headers: file.headers, col_sep: file.col_sep, encoding: file.encoding) do |row|
            mmsg=validate_row(row)
            if mmsg.result
              csv<<row.fields
            else
              unless msg.result
                msg.result=false
                msg.content = "请下载错误文件<a href='/files/#{Base64.encode64(tmp_file)}'>#{::File.basename(tmp_file)}</a>"
              end
              csv<<(row.fields<<mmsg.content)
            end
          end
        end
        return msg
      end

      def self.validate_row(row)
        msg=Message.new(contents: [])
        unless Part.find_by_nr(row['Part Nr'])
          msg.contents<<"Part Nr:#{row['Part Nr']}不存在"
        end

        unless Part.find_by_nr(row['Component Nr'])
          msg.contents<<"Component Nr:#{row['Component Nr']}不存在"
        end

        unless msg.result=(msg.contents.size==0)
          msg.content=msg.contents.join('/')
        end
        puts msg.to_json
        return msg
      end
    end
  end
end
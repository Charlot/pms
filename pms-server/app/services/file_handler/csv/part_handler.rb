require 'csv'
module FileHandler
  module Csv
    class PartHandler<Base
      IMPORT_HEADERS=['Part Nr','Custom Nr','Type','Strip Length'] #Resource Group 和 Measure Unit后加
      INVALID_CSV_HEADERS=IMPORT_HEADERS<<'Error MSG'

      def self.import(file)
      	msg = Message.new
      	begin
      		validate_msg = validate_import(file)
      		if validate_msg.result
      			Part.transaction do
      				CSV.foreach(file.file_path,headers: file.headers,col_sep: file.col_sep,encoding: file.encoding) do |row|
      					part = Part.find_by_nr(row['Part Nr'])
      					unless part
      						Part.create({nr:row['Part Nr'],custom_nr: row['Custom Nr'],type:row['Type'],strip_length:row['Strip Length']})
      					else
      						part.update_attributes({custom_nr:row['Custom Nr'],type:row['Type'],strip_length:row['Strip Length']})
      					end
      				end
      			end
      			msg.result = true
      			msg.content = 'Part 上传成共'
      		else
      			msg.result = false
      			msg.content = validate_msg.content
      		end
      	rescue => e
      		puts e.backtrace
      		msg.content = e.message
        end
        return msg
      end

      def self.validate_import(file)
        tmp_file=full_tmp_path(file.file_name)
        msg=Message.new(result: true)
        CSV.open(tmp_file, 'wb', write_headers: true,
                 headers: INVALID_CSV_HEADERS, col_sep: file.col_sep, encoding: file.encoding) do |csv|
          CSV.foreach(file.file_path, headers: file.headers, col_sep: file.col_sep, encoding: file.encoding) do |row|
            mmsg = validate_row(row)
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
        msg=Message.new(contents: [])
        unless PartType.has_value? row['Type'].to_i
          msg.contents<<"Type:#{row['Type']}不正确"
        end

        unless msg.result=(msg.contents.size==0)
          msg.content=msg.contents.join('/')
        end
        return msg
      end
    end
  end
end

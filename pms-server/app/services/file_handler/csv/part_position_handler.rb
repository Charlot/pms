require 'csv'
module FileHandler
  module Csv
    class PartPositionHandler<Base
      IMPORT_HEADERS=['Part Nr', 'Storage', 'Description']
      INVALID_CSV_HEADERS = IMPORT_HEADERS<<'Error MSG'

      def self.import(file)
        msg = Message.new
        begin
          validate_msg = validate_import(file)
          if validate_msg.result
            PartPosition.transaction do
              CSV.foreach(file.file_path, headers: file.headers, col_sep: file.col_sep, encoding: file.encoding) do |row|
                part = Part.find_by_nr(row['Part Nr'])
                part_position = PartPosition.find_by_part_id(part.id)
                unless part_position
                  part_position = PartPosition.new({part_id: part.id, storage: row['Storage'], description: row['Description']})
                  part_position.save
                else
                  part_position.update({storage: row['Storage'], description: row['Description']})
                end
              end
            end
            msg.result = true
            msg.content = "Cutting零件库位导入成功!"
          else
            msg.result = false
            msg.content = validate_msg.content
          end
        rescue => e
          puts e.backtrace
          msg.result = false
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
        msg = Message.new({contents: []})

        unless Part.find_by_nr(row['Part Nr'])
          msg.conents << "Part Nr: #{row['Part Nr']} Not Found!"
        end

        unless msg.result=(msg.contents.size==0)
          msg.content=msg.contents.join('/')
        end
        return msg
      end
    end
  end
end
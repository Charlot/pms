require 'csv'
module FileHandler
  module Csv
    class MachineCombinationHandler<Base
      IMPORT_HEADERS=['Machine Nr', 'W1', 'T1', 'T2', 'S1', 'S2']
      INVALID_CSV_HEADERS=IMPORT_HEADERS<<'Error MSG'

      def self.import(file)
        msg = Message.new
        begin
          validate_msg = validate_import(file)
          if validate_msg.result
            MachineCombination.transaction do
              CSV.foreach(file.file_path, headers: file.headers, col_sep: file.col_sep, encoding: file.encoding) do |row|
                row.strip
                machine = Machine.find_by_nr(row['Machine Nr'])
                machine_combination = MachineCombination.new
                ['W1', 'T1', 'T2', 'S1', 'S2'].each { |header|
                  if row[header].present?
                    part = Part.find_by_nr(row[header])
                    machine_combination.send("#{header.downcase}=", part.id)
                  end
                }
                machine_combination.machine = machine
                machine_combination.save
              end
            end
            msg.result = true
            msg.content = 'Machine Combination 上传成功'
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
        msg = Message.new(contents: [])
        machine = Machine.find_by_nr(row['Machine Nr'])
        unless machine
          msg.contents << "Machine Nr: #{row['Machine Nr']} 不存在！"
        end

        ['W1', 'T1', 'T2', 'S1', 'S2'].each { |header|
          if row[header].present?
            unless Part.find_by_nr(row[header])
              msg.contents << "#{header}: #{row[header]} 未找到！"
            end
          end
        }

        unless msg.result = (msg.contents.size == 0)
          msg.content=msg.contents.join('/')
        end
        return msg
      end
    end
  end
end
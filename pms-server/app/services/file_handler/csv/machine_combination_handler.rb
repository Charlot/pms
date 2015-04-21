require 'csv'
module FileHandler
  module Csv
    class MachineCombinationHandler<Base
      IMPORT_HEADERS=['Machine Nr', 'W1', 'T1', 'T2', 'S1', 'S2']
      INVALID_CSV_HEADERS=IMPORT_HEADERS<<'Error MSG'

      def self.export(user_agent)
        msg = Message.new
        begin
          tmp_file = MachineCombinationHandler.full_tmp_path('机器组合.csv') unless tmp_file

          CSV.open(tmp_file, 'wb', write_headers: true,
                   headers: IMPORT_HEADERS,
                   col_sep: SEPARATOR, encoding: MachineCombinationHandler.get_encoding(user_agent)) do |csv|
            MachineCombination.all.each_with_index do |mc,i|
              parts = {}
              ['w1','t1','t2','s1','s2'].each do |p|
                part = Part.find_by_id(mc.send(p))
                if part
                  parts[p] = part.nr
                else
                  parts[p] = nil
                end
              end
              csv<<[
                  mc.machine_nr,
                  parts['w1'],
                  parts['t1'],
                  parts['t2'],
                  parts['s1'],
                  parts['s2']
              ]
            end
          end
          msg.result =true
          msg.content =tmp_file
        rescue => e
          msg.content =e.message
        end
        msg
      end

      def self.import(file)
        msg = Message.new
        begin
          validate_msg = validate_import(file)
          if validate_msg.result
            MachineCombination.transaction do
              CSV.foreach(file.file_path, headers: file.headers, col_sep: file.col_sep, encoding: file.encoding) do |row|
                row.strip
                params = {}
                machine = Machine.find_by_nr(row['Machine Nr'])
                params[:machine_id] = machine.id

                ['W1', 'T1', 'T2', 'S1', 'S2'].each { |header|
                  if row[header].present?
                    part = Part.find_by_nr(row[header])
                    params["#{header.downcase}".to_sym] = part.id
                  end
                }

                puts params
                machine_combination = MachineCombination.where(params).first

                if machine_combination
                  puts "更新".red
                  machine_combination.update(params)
                else
                  puts "新建".red
                  MachineCombination.create(params)
                end
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
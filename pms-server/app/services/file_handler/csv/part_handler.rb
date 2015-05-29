require 'csv'
module FileHandler
  module Csv
    class PartHandler<Base
      IMPORT_HEADERS=['Part Nr', 'Custom Nr', 'Type', 'Strip Length', 'Color', 'Color Desc', 'Component Type', 'Cross Section', 'Operator']
      INVALID_CSV_HEADERS=IMPORT_HEADERS<<'Error MSG'

      def self.import(file)
        msg = Message.new
        begin
          validate_msg = validate_import(file)
          if validate_msg.result
            Part.transaction do
              CSV.foreach(file.file_path, headers: file.headers, col_sep: file.col_sep, encoding: file.encoding) do |row|
                row.strip
                part = Part.find_by_nr(row['Part Nr'])
                params = {}
                IMPORT_HEADERS.each { |header|
                  unless (row[header].nil? || header_to_attr(header).nil?)
                    params[header_to_attr(header)] = row[header]
                  end
                }
                puts params
                unless part
                  Part.create(params)
                else
                  puts "Update-------------------------"
                  if row['Operator'].nil? || row['Operator']=='update'
                    part.update(params.except(:nr))
                  elsif row['Operator']=='destory'
                    part.destroy
                  end

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

      def self.update(file)
        msg = Message.new
        begin
          Part.transaction do
            CSV.foreach(file.file_path, headers: file.headers, col_sep: file.col_sep, encoding: file.encoding) do |row|
              row.strip
              part = Part.find_by_nr(row['Part Nr'])
              params = {}
              IMPORT_HEADERS.each { |header|
                unless (row[header].nil? || header_to_attr(header).nil?)
                  params[header_to_attr(header)] = row[header]
                end
              }
              if part
                part.update(params.except(:nr))
              end
            end
          end
          msg.result = true
          msg.content = 'Part 更新成功'
        rescue => e
          puts e.backtrace
          msg.content = e.message
        end
        return msg
      end

      def self.export(user_agent)
        msg = Message.new
        begin
          tmp_file = KanbanHandler.full_tmp_path('part.csv') unless tmp_file

          CSV.open(tmp_file, 'wb', write_headers: true,
                   headers: IMPORT_HEADERS,
                   col_sep: SEPARATOR, encoding: PartHandler.get_encoding(user_agent)) do |csv|
            Part.all.each do |part|
              csv<<[
                  part.nr,
                  part.custom_nr,
                  part.type,
                  part.strip_length,
                  part.color,
                  part.color_desc,
                  part.component_type,
                  part.cross_section,
                  'update'
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

      def self.header_to_attr header
        case header
          when 'Part Nr'
            :nr
          when 'Custom Nr'
            :custom_nr
          when 'Type'
            :type
          when 'Strip Length'
            :strip_length
          when 'Color'
            :color
          when 'Color Desc'
            :color_desc
          when 'Component Type'
            :component_type
          when 'Cross Section'
            :cross_section
          else
        end
      end

      def self.get_encoding(user_agent)
        os=System::Base.os_by_user_agent(user_agent)
        case os
          when 'windows'
            return 'GB18030:UTF-8'
          when 'linux', 'macintosh'
            return 'UTF-8:UTF-8'
          else
            return 'UTF-8:UTF-8'
        end
      end
    end
  end
end

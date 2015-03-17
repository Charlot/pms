require 'csv'
module FileHandler
  module Csv
    class ProcessEntitySemiAutoHandler<Base
      IMPORT_HEADERS=['Nr', 'Name', 'Description', 'Stand Time', 'Template Code', 'WorkStation Type', 'Cost Center', 'Template Fields']
      INVALID_CSV_HEADERS=IMPORT_HEADERS<<'Error MSG'

      def self.import(file)
        msg = Message.new
        begin
          validate_msg = validate_import(file)
          if validate_msg.result
            ProcessEntity.transaction do
              CSV.foreach(file.file_path, headers: file.headers, col_sep: file.col_sep, encoding: file.encoding) do |row|
                process_template = ProcessTemplate.find_by_code(row['Template Code'])
                params = {}
                params =  params.merge({nr: row['Nr'], name: row['Name'], description: row['Description'], stand_time: row['Stand Time'], process_template_id: process_template.id})
                #TODO add WorkStation Type and Cost Center
                process_entity = ProcessEntity.new(params)
                process_entity.process_template = process_template
                process_entity.save

                custom_fields_val = row['Template Fields'].split(',')
                custom_fields_splited = {}
                custom_fields_val.each_with_index { |val, index|
                  if val =~ /\//
                    vals = val.split('/')
                    custom_fields_splited[index] = vals[1]
                    custom_fields_val[index] = vals[0]
                  end
                }
                puts custom_fields_val
                puts custom_fields_splited

                process_entity.custom_fields.each_with_index do |cf, index|
                  #TODO is_for_out_stock怎么来的？
                  cv = CustomValue.new(custom_field_id: cf.id, is_for_out_stock: custom_fields_splited.has_key?(index), value: cf.get_field_format_value(custom_fields_val[index]))
                  process_entity.custom_values<<cv
                end

                process_entity.custom_values.each_with_index do |cv, index|
                  cf=cv.custom_field
                  if CustomFieldFormatType.part?(cf.field_format)
                    #TODO quantity是如何计算的
                    process_entity.process_parts<<ProcessPart.new(part_id: cv.value, quantity: custom_fields_splited[index])
                  end
                end
              end
            end
            msg.result = true
            msg.content = '半自动工艺上传成功'
          else
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
        msg = Message.new({result:true})
        #TODO Validation
        #TODO Validate Template Fields with CustomField.instance.validate_format_field(value)
        return msg
      end
    end
  end
end
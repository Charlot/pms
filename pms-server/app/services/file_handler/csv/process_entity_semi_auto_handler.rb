require 'csv'
module FileHandler
  module Csv
    class ProcessEntitySemiAutoHandler<Base
      IMPORT_HEADERS=['Nr', 'Name', 'Description', 'Stand Time','Product Nr','Template Code', 'WorkStation Type', 'Cost Center', 'Template Fields']
      INVALID_CSV_HEADERS=IMPORT_HEADERS<<'Error MSG'

      def self.import(file)
        msg = Message.new
        begin
          validate_msg = validate_import(file)
          if validate_msg.result
            ProcessEntity.transaction do
              CSV.foreach(file.file_path, headers: file.headers, col_sep: file.col_sep, encoding: file.encoding) do |row|
                process_template = ProcessTemplate.find_by_code(row['Template Code'])
                product = Part.find_by_nr(row['Product Nr'])
                #part = Part.find_by_nr(row['Wire Nr'])
                params = {}
                params =  params.merge({nr: row['Nr'], name: row['Name'], description: row['Description'], stand_time: row['Stand Time'],product_id:product.id, process_template_id: process_template.id})
                process_entity = ProcessEntity.new(params)
                process_entity.process_template = process_template
                process_entity.save

                custom_fields_val = row['Template Fields'].split(',')

                process_entity.custom_fields.each_with_index do |cf, index|
                  cv = nil
                  if CustomFieldFormatType.part?(cf.field_format)
                    if  Part.find_by_nr(custom_fields_val[index])
                      cv = CustomValue.new(custom_field_id: cf.id, is_for_out_stock: true, value: cf.get_field_format_value(custom_fields_val[index]))
                    else
                      cv = CustomValue.new(custom_field_id: cf.id, is_for_out_stock: true, value: cf.get_field_format_value("#{product.nr}_#{custom_fields_val[index]}"))
                    end
                  else
                    cv = CustomValue.new(custom_field_id: cf.id, is_for_out_stock: true, value: cf.get_field_format_value(custom_fields_val[index]))
                  end
                  process_entity.custom_values<<cv if cv
                end

                process_entity.custom_values.each_with_index do |cv, index|
                  cf=cv.custom_field
                  if CustomFieldFormatType.part?(cf.field_format)
                    process_entity.process_parts<<ProcessPart.new(part_id: cv.value, quantity: 1)
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
        msg = Message.new({result:true,contents:[]})
        #验证步骤号
        if ProcessEntity.find_by_nr(row['Nr'])
          msg.contents<<"Nr: #{row['Nr']}，已经存在"
        end

        #验证零件
        product = Part.where({nr:row['Product Nr'],type:PartType::PRODUCT}).first
        #wire = Part.where({nr:"#{row['Product Nr']}~#{row['Wire Nr']}"},type:PartType::PRODUCT_SEMIFINISHED)
        if product.nil?
          msg.contents << "Product Nr: #{row['Product Nr']}不存在"
        end

        #if wire.nil?
        #  msg.contents << "Wire Nr: #{row['Wire Nr']}不存在"
        #end

        #验证模板
        template = ProcessTemplate.find_by_code(row['Template Code'])
        if template.nil?
          msg.contents << "Template Code: #{row['Template Code']}不存在"
        end

        custom_fields_val = row['Template Fields'].split(',')
        template.custom_fields.each_with_index do |cf, index|
          if CustomFieldFormatType.part?(cf.field_format)
            if Part.find_by_nr(custom_fields_val[index])
              next
            elsif  Part.find_by_nr("#{product.nr}_#{custom_fields_val[index]}")
              next
            else
              msg.contents << "Template Fildes: #{custom_fields_val[index]} 未找到"
            end
          end
        end

        unless msg.result=(msg.contents.size==0)
          msg.content=msg.contents.join('/')
        end

        return msg
      end
    end
  end
end
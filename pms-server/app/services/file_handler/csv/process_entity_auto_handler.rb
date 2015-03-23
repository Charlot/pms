require 'csv'
module FileHandler
  module Csv
    class ProcessEntityAutoHandler<Base
      IMPORT_HEADERS=['Nr','Name','Description','Stand Time','Product Nr','Wire Nr','Template Code','WorkStation Type','Cost Center',
                      'Component','Qty Factor','Bundle Qty',
                      'T1','T1 Qty Factor','T1 Strip Length',
                      'T2','T2 Qty Factor','T2 Strip Length',
                      'S1','S1 Qty Factor',
                      'S2','S2 Qty Factor'
      ]
      INVALID_CSV_HEADERS=IMPORT_HEADERS<<'Error MSG'

      def self.import(file)
        msg = Message.new
        begin
          validate_msg = validate_import(file)
          if validate_msg.result
            ProcessEntity.transaction do
              CSV.foreach(file.file_path,headers: file.headers,col_sep: file.col_sep,encoding: file.encoding) do |row|
                process_template = ProcessTemplate.find_by_code(row['Template Code'])
                product = Part.find_by_nr(row['Product Nr'])
                params = {}
                params = params.merge({nr:row['Nr'],name:row['Name'],description:row['Description'],stand_time:row['Stand Time'],product_id:product.id,process_template_id:process_template.id})
                #TODO add WorkStation Type and Cost Center
                process_entity = ProcessEntity.new(params)
                process_entity.process_template = process_template
                process_entity.save

                custom_fields = {}
                ['Component','Qty Factor','Bundle Qty', 'T1','T1 Qty Factor','T1 Strip Length', 'T2','T2 Qty Factor','T2 Strip Length', 'S1','S1 Qty Factor', 'S2','S2 Qty Factor'].each{|header|
                  custom_fields = custom_fields.merge(header_to_custom_fields(header,row[header])) if row[header]
                }
                custom_fields.each do |k,v|
                  cf = process_entity.custom_fields.find{|cf| cf.name == k.to_s}
                  cv = CustomValue.new(custom_field_id:cf.id,is_for_out_stock: cf.is_for_out_stock,value:cf.get_field_format_value(v))
                  process_entity.custom_values<<cv
                end

                process_entity.custom_values.each do |cv|
                  cf=cv.custom_field
                  if CustomFieldFormatType.part?(cf.field_format)
                    process_entity.process_parts<<ProcessPart.new(part_id: cv.value, quantity: process_entity.process_part_quantity_by_cf(cf.name.to_sym))
                  end
                end
              end
            end
            msg.result = true
            msg.content = '全自动工艺上传成功'
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
        msg = Message.new({result:true,contents:[]})
        #验证步骤号
        if ProcessEntity.find_by_nr(row['Nr'])
          msg.contents<<"Nr: #{row['Nr']}，已经存在"
        end

        #验证零件
        product = Part.where({nr:row['Product Nr'],type:PartType::PRODUCT}).first
        wire = Part.where({nr:"#{row['Product Nr']}~#{row['Wire Nr']}"},type:PartType::PRODUCT_SEMIFINISHED)
        if product.nil?
          msg.contents << "Product Nr: #{row['Product Nr']}不存在"
        end

        if wire.nil?
          msg.contents << "Wire Nr: #{row['Wire Nr']}不存在"
        end

        #验证模板
        template = ProcessTemplate.find_by_code(row['Template Code'])
        if template.nil?
          msg.contents << "Template Code: #{row['Template Code']}不存在"
        end

        #验证步骤属性
        ['T1','T2','S1','S2','Component'].each{|header|
          material = Part.find_by_nr(row[header])
          if material.nil?
            msg.contents << "#{header}: #{row[header]}不存在"
          end

          if material && PartType.is_material?(material.type)
            puts "============"
            puts msg.contents.nil?
            puts "#{header}: #{row[header]}零件类型错误"
            msg.contents << "#{header}: #{row[header]}零件类型错误"
          end
        }

        unless msg.result=(msg.contents.size==0)
          msg.content=msg.contents.join('/')
        end

        return msg
      end

      def self.header_to_custom_fields(header,value)
        case header
        when 'Wire NO'
          {default_wire_nr:value}
        when 'Component'
          {wire_nr:value}
        when 'Qty Factor'
          {wire_qty_factor:value}
        when 'Bundle Qty'
          {default_bundle_qty:value}
        when 'T1'
          default_strip_length = 0
          if part = Part.find_by_nr(value)
            default_strip_length = part.strip_length
          end
          {t1:value,t1_default_strip_length:default_strip_length}
        when 'T1 Qty Factor'
          {t1_qty_factor:value}
        when 'T1 Strip Length'
          {t1_strip_length:value}
        when 'T2'
          default_strip_length = 0
          default_strip_length = part.strip_length if part = Part.find_by_nr(value)
          {t2:value,t2_default_strip_length:default_strip_length}
        when 'T2 Qty Factor'
          {t2_qty_factor:value}
        when 'T2 Strip Length'
          {t2_strip_length:value}
        when 'S1'
          {s1:value}
        when 'S1 Qty Factor'
          {s1_qty_factor:value}
        when 'S2'
          {s2:value}
        when 'S2 Qty Factor'
          {s2_qty_factor:value}
        else
          {}
        end
      end
    end
  end
end
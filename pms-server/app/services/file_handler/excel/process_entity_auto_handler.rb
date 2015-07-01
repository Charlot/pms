module FileHandler
  module Excel
    class ProcessEntityAutoHandler<Base
      HEADERS=[
          'Nr', 'Name', 'Description', 'Stand Time', 'Product Nr', 'Template Code', 'WorkStation Type', 'Cost Center',
          'Wire NO', 'Component', 'Qty Factor', 'Bundle Qty',
          'T1', 'T1 Qty Factor', 'T1 Strip Length',
          'T2', 'T2 Qty Factor', 'T2 Strip Length',
          'S1', 'S1 Qty Factor',
          'S2', 'S2 Qty Factor', 'Operator'
      ]
      STRING_HEADERS=['Component', 'T1', 'T2', 'S1', 'S2']

      def self.import(file)
        msg = Message.new
        book = Roo::Excelx.new file.full_path
        book.default_sheet = book.sheets.first
        begin
          validate_msg = validate_import(file)
          if validate_msg.result
            ProcessEntity.transaction do
              2.upto(book.last_row) do |line|
                row = {}
                HEADERS.each_with_index do |k, i|
                  row[k] = book.cell(line, i+1).to_s.strip
                  if STRING_HEADERS.include?(k)
                    row[k]=row[k].sub(/\.0/, '')
                  end
                end

                process_template = ProcessTemplate.find_by_code(row['Template Code'].to_i.to_s)
                product = Part.find_by_nr(row['Product Nr'])
                params = {}
                params = params.merge({
                                          nr: row['Nr'],
                                          name: row['Name'],
                                          description: row['Description'],
                                          stand_time: row['Stand Time'],
                                          product_id: product.id,
                                          process_template_id: process_template.id
                                      })

                case row['Operator']
                  when 'new', ''
                    if row['Wire NO'].present?
                      part = Part.where({nr: "#{row['Product Nr']}_#{row['Wire NO']}", type: PartType::PRODUCT_SEMIFINISHED}).first
                      if part.nil?
                        part = Part.create({nr: "#{row['Product Nr']}_#{row['Wire NO']}", type: PartType::PRODUCT_SEMIFINISHED})
                      end
                    end

                    #TODO add WorkStation Type and Cost Center
                    process_entity = ProcessEntity.new(params)
                    process_entity.process_template = process_template
                    process_entity.save

                    custom_fields = {}
                    ['Wire NO', 'Component', 'Qty Factor', 'Bundle Qty', 'T1', 'T1 Qty Factor', 'T1 Strip Length', 'T2', 'T2 Qty Factor', 'T2 Strip Length', 'S1', 'S1 Qty Factor', 'S2', 'S2 Qty Factor'].each { |header|
                      custom_fields = custom_fields.merge(header_to_custom_fields(header, row[header])) if row[header]
                    }

                    custom_fields.each do |k, v|
                      if cf = process_entity.custom_fields.find { |cf| cf.name == k.to_s }
                        if cf.name == "default_wire_nr"
                          puts "#{product.nr}_#{v}".red
                          cv = CustomValue.new(custom_field_id: cf.id, is_for_out_stock: cf.is_for_out_stock, value: cf.get_field_format_value("#{product.nr}_#{v}"))
                        else
                          cv = CustomValue.new(custom_field_id: cf.id, is_for_out_stock: cf.is_for_out_stock, value: cf.get_field_format_value(v))
                        end
                        process_entity.custom_values<<cv
                      end
                    end

                    process_entity.custom_values.each do |cv|
                      cf=cv.custom_field
                      qty= process_entity.process_part_quantity_by_cf(cf.name.to_sym).to_f
                      if (part=Part.find_by_id(cv.value)) && (part.type==PartType::MATERIAL_WIRE) && qty>10
                        qty=qty/1000
                      end if Setting.auto_convert_material_length?

                      if CustomFieldFormatType.part?(cf.field_format) && cf.is_for_out_stock
                        process_entity.process_parts<<ProcessPart.new(part_id: cv.value, quantity: qty, custom_value_id: cv.id)
                      end
                    end
                  when 'update'
                    pe = ProcessEntity.where({nr: params[:nr], product_id: product.id}).first
                    wire = Part.where({nr: "#{product.nr}_#{row['Wire NO']}", type: PartType::PRODUCT_SEMIFINISHED}).first
                    if wire.nil?
                      part = Part.create({nr: "#{row['Product Nr']}_#{row['Wire NO']}", type: PartType::PRODUCT_SEMIFINISHED})
                    end
                    pe.update(params.except(:nr))

                    custom_fields = {}
                    ['Wire NO', 'Component', 'Qty Factor', 'Bundle Qty', 'T1', 'T1 Qty Factor', 'T1 Strip Length', 'T2', 'T2 Qty Factor', 'T2 Strip Length', 'S1', 'S1 Qty Factor', 'S2', 'S2 Qty Factor'].each { |header|
                      custom_fields = custom_fields.merge(header_to_custom_fields(header, row[header])) if row[header]
                    }

                    custom_fields.each do |k, v|
                      if cf = pe.custom_fields.find { |cf| cf.name == k.to_s }
                        if cv = pe.custom_values.where({custom_field_id: cf.id}).first
                          #找到了，更新
                          #puts "找到了".red
                          puts "#{product.nr}_#{v}".green
                          if cf.name == "default_wire_nr"
                            cv = cv.update(value: cf.get_field_format_value("#{product.nr}_#{v}"))
                          else
                            cv = cv.update(value: cf.get_field_format_value(v))
                          end
                        else
                          #未找到，创建
                          if cf.name == "default_wire_nr"
                            cv = CustomValue.new(custom_field_id: cf.id, is_for_out_stock: cf.is_for_out_stock, value: cf.get_field_format_value("#{product.nr}_#{v}"))
                          else
                            cv = CustomValue.new(custom_field_id: cf.id, is_for_out_stock: cf.is_for_out_stock, value: cf.get_field_format_value(v))
                          end
                          pe.custom_values<<cv
                        end
                      end
                    end

                    # pe.process_parts.destroy_all
                    arrs=pe.process_parts.pluck(:id)
                    pe.custom_values.each do |cv|
                      cf=cv.custom_field
                      if CustomFieldFormatType.part?(cf.field_format) && cf.is_for_out_stock
                        qty= pe.process_part_quantity_by_cf(cf.name.to_sym).to_f
                        if (part=Part.find_by_id(cv.value)) && (part.type==PartType::MATERIAL_WIRE) && qty>10
                          qty=qty/1000
                        end if Setting.auto_convert_material_length?

                        if ppp=pe.process_parts.where(custom_value_id: cv.id,part_id:cv.value).first
                          ppp.update_attributes(quantity:qty)
                          arrs.delete(ppp.id)
                        else
                          pe.process_parts<<ProcessPart.new(part_id: cv.value, quantity: qty, custom_value_id: cv.id)
                        end
                      end
                    end
                    pe.process_parts.where(id:arrs).destroy_all
                    pe.save
                  when 'delete'
                    pe = ProcessEntity.where({nr: params[:nr], product_id: product.id}).first
                  # pe.destroy
                end
              end
            end
            msg.result = true
            msg.content = "导入全自动工艺成功"
          else
            msg.result = false
            msg.content = validate_msg.content
          end
        rescue => e
          puts e.backtrace
          msg.result = false
          msg.content = e.message
        end
        msg
      end

      def self.export(q)
        msg = Message.new
        begin
          tmp_file = full_export_path("(#{q})RoutingAuto.xlsx") unless tmp_file

          p = Axlsx::Package.new
          p.workbook.add_worksheet(:name => "Basic Worksheet") do |sheet|
            sheet.add_row HEADERS
            process_entities = []
            if q.nil?
              process_entities= ProcessEntity.joins(:process_template).where(process_templates: {type: ProcessType::AUTO})
            else
              process_entities = ProcessEntity.search_for(q).select { |pe| pe.process_template_type == ProcessType::AUTO }
            end
            process_entities.each do |pe|
              parts_info = {}

              ['t1', 't2', 's1', 's2'].each { |cf|
                value = pe.send("value_#{cf}")
                if value && part = Part.find_by_id(value)
                  parts_info["#{cf}_custom_nr".to_sym] = part.custom_nr
                  parts_info["#{cf}_nr".to_sym] = part.nr
                else
                  parts_info["#{cf}_custom_nr".to_sym]= nil
                  parts_info["#{cf}_nr".to_sym] = nil
                end
              }
              wire = Part.find_by_id(pe.value_wire_nr)
              sheet.add_row [
                                pe.nr,
                                pe.name,
                                pe.description,
                                pe.stand_time,
                                pe.product_nr,
                                pe.process_template_code,
                                nil,
                                nil,
                                pe.parsed_wire_nr,
                                (wire.nr if wire),
                                pe.value_wire_qty_factor,
                                pe.value_default_bundle_qty,
                                parts_info[:t1_nr],
                                pe.value_t1_qty_factor,
                                pe.t1_strip_length,
                                parts_info[:t2_nr],
                                pe.value_t2_qty_factor,
                                pe.t2_strip_length,
                                parts_info[:s1_nr],
                                pe.value_s1_qty_factor,
                                parts_info[:s2_nr],
                                pe.value_s2_qty_factor,
                                'update'
                            ], types: [
                                 :string, :string, :string, :float, :string, :string, nil, nil,
                                 :string, :string, nil, nil, :string, nil, nil,
                                 :string, nil, nil,
                                 :string, nil, nil,
                                 :string, nil,
                                 :string, nil
                             ]
            end
          end
          p.use_shared_strings = true
          p.serialize(tmp_file)

          msg.result =true
          msg.content =tmp_file
        rescue => e
          puts e.backtrace
          msg.content = e.message
        end
        msg
      end

      def self.validate_import(file)
        tmp_file=full_tmp_path(file.original_name)
        msg = Message.new(result: true)
        book = Roo::Excelx.new file.full_path
        book.default_sheet = book.sheets.first

        p = Axlsx::Package.new
        p.workbook.add_worksheet(:name => "Basic Worksheet") do |sheet|
          sheet.add_row HEADERS+['Error Msg']
          #validate file
          2.upto(book.last_row) do |line|
            row = {}
            HEADERS.each_with_index do |k, i|
              row[k] = book.cell(line, i+1).to_s.strip
              if STRING_HEADERS.include?(k)
                row[k]=row[k].sub(/\.0/, '')
              end
            end

            mssg = validate_row(row, line)
            if mssg.result
              sheet.add_row row.values
            else
              if msg.result
                msg.result = false
                msg.content = "下载错误文件<a href='/files/#{Base64.urlsafe_encode64(tmp_file)}'>#{::File.basename(tmp_file)}</a>"
              end
              sheet.add_row row.values<<mssg.content
            end
          end
        end
        p.use_shared_strings = true
        p.serialize(tmp_file)
        msg
      end

      def self.validate_row(row, line)
        msg = Message.new({result: true, contents: []})
        #验证零件
        product = Part.where({nr: row['Product Nr'], type: PartType::PRODUCT}).first

        if product.nil?
          msg.contents << "Product Nr: #{row['Product Nr']}不存在"

        else
          wire = Part.where({nr: "#{row['Product Nr']}_#{row['Wire NO']}"}, type: PartType::PRODUCT_SEMIFINISHED).first
          pe = ProcessEntity.where({nr: row['Nr'], product_id: product.id})

          case row['Operator']
            when 'new', ''
              #if wire
              #  msg.contents << "Wire NO:#{row['Wire NO']}已经存在"
              #end
              if pe.count > 0
                msg.contents << "Nr :#{row['Nr']}已经存在"
              end
            when 'update'
              if pe.count <= 0
                msg.content << "Nr: #{row['Nr']}未找到"
              end

            #unless wire
            #msg.contents << "Wire NO:#{row['Wire NO']}不存在"
            #end
            when 'delete'
              if pe.count <= 0
                msg.content << "Nr: #{row['Nr']}未找到"
              end
          end

          #验证模板
          template = ProcessTemplate.find_by_code(row['Template Code'].to_i.to_s)
          if template.nil?
            msg.contents << "Template Code: #{row['Template Code'].to_i.to_s}不存在"
          end

          #验证步骤属性
          ['T1', 'T2', 'S1', 'S2', 'Component'].each { |header|
            material = Part.find_by_nr(row[header])
            if material.nil? && row[header].present?
              msg.contents << "#{header}: #{row[header]}不存在"
            end

            if material && !PartType.is_material?(material.type)
              msg.contents << "#{header}: #{row[header]}零件类型错误"
            end
          }
        end
        unless msg.result=(msg.contents.size==0)
          msg.content=msg.contents.join('/')
        end

        return msg
      end

      def self.header_to_custom_fields(header, value)
        case header
          when 'Wire NO'
            {default_wire_nr: value}
          when 'Component'
            {wire_nr: value}
          when 'Qty Factor'
            {wire_qty_factor: value}
          when 'Bundle Qty'
            {default_bundle_qty: value}
          when 'T1'
            default_strip_length = 0
            if part = Part.find_by_nr(value)
              default_strip_length = part.strip_length
            end
            {t1: value, t1_default_strip_length: default_strip_length}
          when 'T1 Qty Factor'
            {t1_qty_factor: value}
          when 'T1 Strip Length'
            {t1_strip_length: value}
          when 'T2'
            default_strip_length = 0
            default_strip_length = part.strip_length if part = Part.find_by_nr(value)
            {t2: value, t2_default_strip_length: default_strip_length}
          when 'T2 Qty Factor'
            {t2_qty_factor: value}
          when 'T2 Strip Length'
            {t2_strip_length: value}
          when 'S1'
            {s1: value}
          when 'S1 Qty Factor'
            {s1_qty_factor: value}
          when 'S2'
            {s2: value}
          when 'S2 Qty Factor'
            {s2_qty_factor: value}
          else
            {}
        end
      end
    end
  end
end
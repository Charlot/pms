module FileHandler
  module Excel
    class ProcessEntitySemiAutoHandler<Base
      HEADERS=[
          'Nr', 'Name', 'Description', 'Stand Time',
          'Product Nr', 'Template Code', 'WorkStation Type',
          'Cost Center', 'Template Fields', 'Wire Nr', 'Remark', 'Operator'
      ]

      def self.export(q)
        msg = Message.new
        begin
          tmp_file = full_export_path("(#{q})RoutingSemiAuto.xlsx") unless tmp_file

          p = Axlsx::Package.new
          p.workbook.add_worksheet(:name => "Basic Worksheet") do |sheet|
            sheet.add_row HEADERS
            process_entities = []
            if q.nil?
              process_entities= ProcessEntity.joins(:process_template).where(process_templates: {type: ProcessType::SEMI_AUTO})
            else
              process_entities = ProcessEntity.search_for(q).select { |pe| pe.process_template_type == ProcessType::SEMI_AUTO }
            end
            process_entities.each do |pe|
              sheet.add_row [
                                pe.nr,
                                pe.name,
                                pe.description,
                                pe.stand_time,
                                pe.product_nr,
                                pe.process_template_code.to_i.to_s,
                                pe.workstation_type,
                                pe.cost_center,
                                pe.template_fields.join(","),
                                pe.parsed_wire_nr,
                                pe.remark,
                                "update"
                            ], types: [:string, :string, :string, :float, :string, :string, :string, :string, :string, :string, :string, :string]
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

      def self.import(file)
        msg = Message.new
        book = Roo::Excelx.new file.full_path
        book.default_sheet = book.sheets.first
        begin
          validate_msg = validate_import(file)
          if validate_msg.result
            # ProcessEntity.transaction do
              2.upto(book.last_row) do |line|

                row = {}
                HEADERS.each_with_index do |k, i|
                  row[k] = book.cell(line, i+1).to_s.strip
                end

                process_template = ProcessTemplate.find_by_code(row['Template Code'].to_i.to_s)
                product = Part.find_by_nr(row['Product Nr'])

                params = {}
                params = params.merge({nr: row['Nr'], name: row['Name'], description: row['Description'], stand_time: row['Stand Time'], remark: row['Remark'], product_id: product.id, process_template_id: process_template.id})

                pe = ProcessEntity.where({product_id: product.id, nr: params[:nr]}).first

                wire = Part.where({nr: "#{product.nr}_#{row['Wire Nr']}", type: PartType::PRODUCT_SEMIFINISHED}).first if row['Wire Nr'].present?

                case row['Operator']
                  when 'new', ''
                    puts "未找到".green
                    process_entity = ProcessEntity.new(params)
                    process_entity.process_template = process_template
                    process_entity.save

                    if wire.nil?
                      wire = Part.create({nr: "#{product.nr}_#{row['Wire Nr']}", type: PartType::PRODUCT_SEMIFINISHED}) if row['Wire Nr'].present?
                    end

                    #default wire nr
                    cf = process_entity.custom_fields.where(name: "default_wire_nr").first

                    if cf && row['Wire Nr'].present?
                      cv = CustomValue.new(custom_field_id: cf.id, is_for_out_stock: false, value: cf.get_field_format_value("#{product.nr}_#{row['Wire Nr']}"))
                      process_entity.custom_values << cv
                    end

                    template_fields = []

                    custom_fields_val = []
                    custom_fields_quantity = []

                    row['Template Fields'].split(',').each do |cf|
                      a = cf.split("|")
                      custom_fields_val << a.first
                      # raise "#{a.to_json}|#{a.size}#{a.count}"
                      if a.count == 2
                        custom_fields_quantity << a.last.to_f
                      else
                        custom_fields_quantity << 1
                      end
                    end

                    puts "#{custom_fields_quantity.to_json}---#{ process_entity.custom_fields.select { |cf| cf.name != "default_wire_nr" }.to_json}"


                    # pe.custom_fields.select { |cf| cf.name != "default_wire_nr" }.each_with_index do |cf,index|
                    #   template_fields << {:type => cf.field_format,:value=>custom_fields_val[index],:ext => custom_fields_quantity[index]}
                    # end
                  # raise "#{custom_fields_quantity.to_json}---#{ process_entity.custom_fields.select { |cf| cf.name != "default_wire_nr" }}"

                    process_entity.custom_fields.select { |cf| cf.name != "default_wire_nr" }.each_with_index do |cf, index|
                      template_fields << {:type => cf.field_format,:value=>custom_fields_val[index],:ext => custom_fields_quantity[index]}
                      cv = nil
                      if CustomFieldFormatType.part?(cf.field_format)
                        if custom_fields_val[index].blank?
                          next
                        end

                        if Part.find_by_nr(custom_fields_val[index])
                          cv = CustomValue.new(custom_field_id: cf.id, is_for_out_stock: true, value: cf.get_field_format_value(custom_fields_val[index]))
                        else
                          cv = CustomValue.new(custom_field_id: cf.id, is_for_out_stock: true, value: cf.get_field_format_value("#{product.nr}_#{custom_fields_val[index]}"))
                        end
                      else
                        cv = CustomValue.new(custom_field_id: cf.id, is_for_out_stock: true, value: cf.get_field_format_value(custom_fields_val[index]))
                      end
                      process_entity.custom_values<<cv if cv
                    end

                    tmp_quantity = template_fields.select { |tf| tf[:type] == "part" }.collect { |a| a[:ext] }

                    process_entity.custom_values.select { |cv| (cv.custom_field.name != "default_wire_nr")&&(cv.custom_field.field_format=="part") }.each_with_index do |cv, index|
                      cf=cv.custom_field
                      qty=tmp_quantity[index].to_f
                      if (part=Part.find_by_id(cv.value)) && (part.type==PartType::MATERIAL_WIRE) && qty>10
                        qty=qty/1000
                      end if Setting.auto_convert_material_length?

                      if CustomFieldFormatType.part?(cf.field_format) && cf.is_for_out_stock
                        process_entity.process_parts<<ProcessPart.new(part_id: cv.value, quantity: qty, custom_value_id: cv.id, custom_value_id: cv.id)
                      end
                    end
                  when 'update'
                    puts "找到了".green

                    if wire.nil? && row['Wire Nr'].present?
                      wire = Part.create({nr: "#{product.nr}_#{row['Wire Nr']}", type: PartType::PRODUCT_SEMIFINISHED})
                    end

                    pe.update(params.except(:nr))
                    if row['Wire Nr'].present? && !pe.parsed_wire_nr.blank? && pe.parsed_wire_nr != row['Wire Nr']
                      pe.wire.update(nr: "#{product.nr}_#{row['Wire Nr']}")
                    end

                    template_fields = []

                    custom_fields_val = []
                    custom_fields_quantity = []

                    row['Template Fields'].split(',').each do |cf|
                      a = cf.split("|")
                      custom_fields_val << a.first
                      if a.count == 2
                        custom_fields_quantity << a.last
                      else
                        custom_fields_quantity << 1
                      end
                    end

                    pe.custom_fields.select { |cf| cf.name != "default_wire_nr" }.each_with_index do |cf, index|
                      template_fields << {:type => cf.field_format, :value => custom_fields_val[index], :ext => custom_fields_quantity[index]}
                    end

                    pe.custom_fields.select { |cf| cf.name != "default_wire_nr" }.each_with_index { |cf, index|
                      cvs = pe.custom_values.where(custom_field_id: cf.id).all
                      cv = pe.custom_values.where(custom_field_id: cf.id).first
                      if cvs.count>1
                        cvs.last(cvs.count-1).each { |c| c.destroy }
                      end
                      if CustomFieldFormatType.part?(cf.field_format)
                        if custom_fields_val[index].blank?
                          if cv
                            cv.destroy
                          end
                          next
                        end

                        if Part.find_by_nr(custom_fields_val[index])
                          if cv
                            cv.update(value: cf.get_field_format_value(custom_fields_val[index]))
                          else
                            cv = CustomValue.new(custom_field_id: cf.id, is_for_out_stock: true, value: cf.get_field_format_value(custom_fields_val[index]))
                            pe.custom_values<<cv
                          end
                        else
                          if cv
                            cv.update(value: cf.get_field_format_value("#{product.nr}_#{custom_fields_val[index]}"))
                          else
                            cv = CustomValue.new(custom_field_id: cf.id, is_for_out_stock: true, value: cf.get_field_format_value("#{product.nr}_#{custom_fields_val[index]}"))
                            pe.custom_values<<cv
                          end
                        end
                      else
                        if cv
                          cv.update(value: cf.get_field_format_value(custom_fields_val[index]))
                        else
                          cv = CustomValue.new(custom_field_id: cf.id, is_for_out_stock: true, value: cf.get_field_format_value(custom_fields_val[index]))
                          pe.custom_values<<cv
                        end
                      end
                    }
                    # pe.process_parts.destroy_all
                    arrs=pe.process_parts.pluck(:id)
                    puts arrs.to_json.yellow
                    temp_quantity = template_fields.select { |tf| tf[:type] == "part" }.collect { |a| a[:ext] }
                    pe.custom_values.select { |cv| (cv.custom_field.name != "default_wire_nr")&&(cv.custom_field.field_format=="part") }.each_with_index do |cv, index|
                      cf=cv.custom_field
                      if CustomFieldFormatType.part?(cf.field_format) && cf.is_for_out_stock
                        # puts "#{template_fields}-----#{cv}".red
                        # puts "#{Part.find_by_id(cv.value).nr},#{temp_quantity[index]},#{index}".red
                        if cv.value #&& Part.find_by_id(cv.value)
                          qty=temp_quantity[index].to_f
                          if (part=Part.find_by_id(cv.value)) && (part.type==PartType::MATERIAL_WIRE) && qty>10
                            qty=qty/1000
                          end if Setting.auto_convert_material_length?
                          if ppp=pe.process_parts.where(custom_value_id: cv.id, part_id: cv.value).first
                            puts "@@@@@@@@@@update process part:#{ppp.to_json}".blue
                            ppp.update_attributes!(quantity: qty)
                            # ppp.update_part_bom
                            arrs.delete(ppp.id)
                          else
                            pe.process_parts<<ProcessPart.new(part_id: cv.value, quantity: qty, custom_value_id: cv.id)
                          end
                        end

                      end
                    end
                    puts arrs.to_json.red

                    pe.process_parts.where(id: arrs).destroy_all
                    pe.save
                  when 'delete'
                    pe.destroy
                end
              end
            # end
            msg.result = true
            msg.content = "导入半自动步骤成功"
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

      def self.validate_import(file)
        tmp_file=full_tmp_path(file.original_name)
        msg = Message.new(result: true)
        book = Roo::Excelx.new file.full_path
        book.default_sheet = book.sheets.first

        p = Axlsx::Package.new

        wire_hash = {}

        p.workbook.add_worksheet(:name => "Basic Worksheet") do |sheet|
          sheet.add_row HEADERS+['Error Msg']
          #validate file
          2.upto(book.last_row) do |line|
            row = {}
            HEADERS.each_with_index do |k, i|
              row[k] = book.cell(line, i+1).to_s.strip
            end

            mssg = validate_row(row, line, wire_hash)
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

      def self.validate_row(row, line, wire_hash)
        msg = Message.new({result: true, contents: []})

        #验证总成号
        product = Part.where({nr: row['Product Nr'], type: PartType::PRODUCT}).first

        if product.nil?
          msg.contents << "Product Nr: #{row['Product Nr']}不存在"
        end

        #验证模板
        puts row
        puts row['Template Code']
        template = ProcessTemplate.find_by_code(row['Template Code'].to_i.to_s)
        if template.nil?
          msg.contents << "Template Code: #{row['Template Code']}不存在"
        end

        #验证步骤号
        pe = ProcessEntity.where({nr: row['Nr'], product_id: product.id})

        #验证生成的线号
        wire = Part.where({nr: "#{row['Product Nr']}_#{row['Wire Nr']}"}, type: PartType::PRODUCT_SEMIFINISHED).first
        case row['Operator']
          when 'new', ''
            if pe.count > 0
              msg.contents << "Nr:#{row['Nr']},步骤已存在"
            end
          #if wire
          #  msg.contents << "Wire Nr:#{row['Wire Nr']},线号已存在"
          #end
          when 'update'
            if pe.count <= 0
              msg.contents << "Nr:#{row['Nr']},步骤不存在"
            end
          when 'delete'
            if pe.count <= 0
              msg.contents << "Nr:#{row['Nr']},步骤不存在"
            end
        end

        #Wire
        if wire.present?
          wire_hash[wire.nr] = 0
        end

        #验证属性
        custom_fields = row['Template Fields'].split(',', -1).collect { |cfv| cfv.strip }
        custom_fields_val = custom_fields.collect { |cf| cf.split("|").first }


        cfs = template.custom_fields.select { |cf| cf.name != "default_wire_nr" }

        puts "======".red
        puts cfs.count
        puts row['Template Fields']
        puts custom_fields_val.count
        puts custom_fields_val.to_json

        if cfs.count != custom_fields_val.count
          msg.contents << "Template Fildes: 逗号数量错误!"
        end

        template.custom_fields.select { |cf| cf.name != "default_wire_nr" }.each_with_index do |cf, index|
          if CustomFieldFormatType.part?(cf.field_format)
            if cf.name == "default_wire_nr" || custom_fields_val[index].blank?
              next
            end

            if Part.find_by_nr(custom_fields_val[index])
              next
            elsif (Part.find_by_nr("#{product.nr}_#{custom_fields_val[index]}") ||wire_hash["#{product.nr}_#{custom_fields_val[index]}"])
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
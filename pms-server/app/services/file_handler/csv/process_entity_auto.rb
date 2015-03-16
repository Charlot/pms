require 'csv'
module FileHanlder
  module Csv
    class ProcessEntityAuto<Base
      IMPORT_HEADERS=['Nr','Name','Description','Stand Time','Template Code','WorkStation Type','Cost Center',
                      'Wire NO','Component','Qty Factor','Bundle Qty',
                      'T1','T1 Qty Factor','T1 Strip Length',
                      'T2','T2 Qty Factor','T2 Strip Length',
                      'S1','S1 Qty Factor',
                      'S2','S2 Qty Factor']
      INVALID_CSV_HEADERS=IMPORT_HEADERS<<'Error MSG'

      def self.import(file)
        msg = Message.new
        begin
          validate_msg = validate_import(file)
          if validate_msg.result
            ProcessEntity.transaction do
              CSV.foreach(file.file_path,headers: file.headers,col_sep: file.col_sep,encoding: file.encoding) do |row|
                process_template = ProcessTemplate.find_by_code(row['Template Code'])
                params = {}
                params.merge({nr:row['NR'],name:row['Name'],description:row['Description'],stand_time:row['Stand Time'],process_template_id:process_template.id})
                #TODO add WorkStation Type and Cost Center
                process_entity = ProcessEntity.new(params)
                process_entity.process_template = process_template
                process_entity.save

                custom_fields = {}
                ['Wire NO','Component','Qty Factor','Bundle Qty', 'T1','T1 Qty Factor','T1 Strip Length', 'T2','T2 Qty Factor','T2 Strip Length', 'S1','S1 Qty Factor', 'S2','S2 Qty Factor'].each{|header|
                  custom_fields.merge(header_to_custom_fields(header,row[header])) if row[header]
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
      end

      def self.validate_row(row)
        #TODO Add validation
        #TODO validate custom field for template
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
          default_strip_length = part.strip_length if part = Part.find_by_nr(value)
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
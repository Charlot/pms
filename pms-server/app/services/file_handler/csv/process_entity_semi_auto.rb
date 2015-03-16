require 'csv'
module FileHandler
  module Csv
    class ProcessEntitySemiAuto<Base
      IMPORT_HEADERS=['Nr','Name','Description','Stand Time','Template Code','WorkStation Type','Cost Center','Template Fields']
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

                  custom_fields_val = row['Template Fields'].split(',')
                  process_entity.custom_fields.each_with_index do |cf,index|
                    #TODO is_for_out_stock怎么来的？
                    cv = CustomValue.new(custom_field_id: cf.id, is_for_out_stock: cf.is_for_out_stock, value: cf.get_field_format_value(custom_fields_val[index]))
                    process_entity.custom_values<<cv
                  end

                  process_entity.custom_values.each do |cv|
                    cf=cv.custom_field
                    if CustomFieldFormatType.part?(cf.field_format)
                      #TODO quantity是如何计算的
                      process_entity.process_parts<<ProcessPart.new(part_id: cv.value, quantity: 100)
                    end
                  end
                end
              end
            else

            end
        rescue => e
        end
      end

      def self.validate_row(row)
        #TODO Validation
        #TODO Validate Template Fields with CustomField.instance.validate_format_field(value)
      end
    end
  end
end
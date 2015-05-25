module FileHandler
  module Csv
    class ProcessEntityHandler<Base
      EXPORT_CSV_HEADERS=%w(NO Nr ProductNr)

      EXPORT_AUTO_CSV_HEADERS=[
          'Nr','Name','Description','Stand Time','Product Nr',
          'Template Code','WorkStation Type','Cost Center',
          'Wire NO','Component','Qty Factor','Bundle Qty',
          'T1','T1 Qty Factor','T1 Strip Length',
          'T2','T2 Qty Factor','T2 Strip Length',
          'S1','S1 Qty Factor',
          'S2','S2 Qty Factor'
      ]
      EXPORT_SEMI_CSV_HEADERS=[
          'Nr', 'Name', 'Description', 'Stand Time',
          'Product Nr','Template Code', 'WorkStation Type',
          'Cost Center', 'Template Fields','Wire Nr'
      ]

      def self.export_unused(user_agent)
        msg = Message.new
        begin
          tmp_file = ProcessEntityHandler.full_tmp_path('未使用的步骤.csv') unless tmp_file

          CSV.open(tmp_file, 'wb', write_headers: true,
                   headers: EXPORT_CSV_HEADERS,
                   col_sep: SEPARATOR, encoding: ProcessEntityHandler.get_encoding(user_agent)) do |csv|
            ProcessEntity.all.each_with_index do |pe, i|
              if pe.kanban_process_entities.count <= 0
                csv<<[i+1,
                      pe.nr,
                      pe.product_nr
                ]
              end
            end
          end
          msg.result =true
          msg.content =tmp_file
        rescue => e
          msg.content =e.message
        end
        msg
      end

      def self.export_auto(user_agent)
        msg = Message.new
        begin
          tmp_file = KanbanHandler.full_tmp_path('kanbans.csv') unless tmp_file

          CSV.open(tmp_file, 'wb', write_headers: true,
                   headers: EXPORT_AUTO_CSV_HEADERS,
                   col_sep: SEPARATOR, encoding: ProcessEntityHandler.get_encoding(user_agent)) do |csv|
            ProcessEntity.joins(:process_template).where(process_templates:{type:ProcessType::AUTO}).all.each_with_index do |pe|
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

              csv << [
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
                  pe.value_t1_strip_length,
                  parts_info[:t2_nr],
                  pe.value_t2_qty_factor,
                  pe.value_t2_strip_length,
                  parts_info[:s1_nr],
                  pe.value_s1_qty_factor,
                  parts_info[:s2_nr],
                  pe.value_s2_qty_factor
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

      def self.export_semi(user_agent)

      end
    end
  end
end
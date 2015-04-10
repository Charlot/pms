module FileHandler
  module Csv
    class ProcessEntityHandler<Base
      EXPORT_CSV_HEADERS=%w(NO Nr ProductNr)
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
    end
  end
end
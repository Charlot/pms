module FileHandler
  module Excel
    class ProcessEntitySemiAutoHandler<Base
      HEADERS=[
          'Nr', 'Name', 'Description', 'Stand Time',
          'Product Nr','Template Code', 'WorkStation Type',
          'Cost Center', 'Template Fields','Wire Nr','Operator'
      ]

      def self.export(q)
        msg = Message.new
        begin
          tmp_file = full_tmp_path('process_entity_semi_auto.xlsx') unless tmp_file

          p = Axlsx::Package.new
          p.workbook.add_worksheet(:name => "Basic Worksheet") do |sheet|
            sheet.add_row HEADERS
            process_entities = []
            if q.nil?
              process_entities= ProcessEntity.joins(:process_template).where(process_templates: {type: ProcessType::SEMI_AUTO})
            else
              process_entities = ProcessEntity.search_for(q).select{|pe| pe.process_template_type == ProcessType::SEMI_AUTO}
            end
            process_entities.each do |pe|
              sheet.add_row [
                                pe.nr,
                                pe.name,
                                pe.description,
                                pe.stand_time,
                                pe.product_nr,
                                pe.process_template_code,
                                pe.workstation_type,
                                pe.cost_center,
                                pe.template_fields.join(","),
                                pe.parsed_wire_nr,
                                "update"
                            ], types: [:string,:string,:string,:float]
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

      def self.validate_row(row,line)

      end
    end
  end
end
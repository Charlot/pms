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
          tmp_file = full_tmp_path('process_entity_auto.xlsx') unless tmp_file

          p = Axlsx::Package.new
          p.workbook.add_worksheet(:name => "Basic Worksheet") do |sheet|
            sheet.add_row HEADERS
            process_entities = []
            if q.nil?
              process_entities= ProcessEntity.joins(:process_template).where(process_templates: {type: ProcessType::AUTO})
            else
              process_entities = ProcessEntity.search_for(q)
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
                                pe.value_t1_strip_length,
                                parts_info[:t2_nr],
                                pe.value_t2_qty_factor,
                                pe.value_t2_strip_length,
                                parts_info[:s1_nr],
                                pe.value_s1_qty_factor,
                                parts_info[:s2_nr],
                                pe.value_s2_qty_factor,
                                'update'
                            ], types: [
                                 :string,:string,:string,:float,:string,:string,nil,nil,
                                 :string,:string,nil,nil,:string,nil,nil,
                                 :string,nil,nil,
                                 :string,nil,nil,
                                 :string,nil,
                                 :string,nil
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
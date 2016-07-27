module FileHandler
  module Excel
    class CrimpConfigurationHandler<Base
      HEADERS=[
          "ID", "custom_id", "tool_id", "part_id", "wire_group_name", "cross_section", "min_pulloff_value", "crimp_height", "crimp_height_iso",
          "crimp_width", "crimp_width_iso", "i_crimp_height", "i_crimp_height_iso", "i_crimp_width", "i_crimp_width_iso", "operator"
      ]

      def self.import(file)
        puts '-----------------------------------------------------------------'
        msg = Message.new
        book = Roo::Excelx.new file.full_path
        book.default_sheet = book.sheets.first

        validate_msg = validate_import(file)
        if validate_msg.result
          #validate file
          begin
            CrimpConfiguration.transaction do

              2.upto(book.last_row) do |line|
                row = {}
                HEADERS.each_with_index do |k, i|
                  row[k] = book.cell(line, i+1).to_s.strip
                  row[k]=row[k].sub(/\.0/, '') if k=='part_id' || k=='custom_id' || k=='tool_id'
                end

                tool=Tool.find_by_nr(row["tool_id"])
                row["tool_id"]=tool.id

                if !row["ID"].blank? && cc=CrimpConfiguration.find_by_id(row["ID"])
                  if row['operator'].blank? || row['operator']=='update'
                    cc.update(row.except("ID", "operator"))
                  elsif row['operator']=='delete'
                    cc.destroy
                  end
                elsif row["ID"].blank?
                  if row['operator'].blank? &&
                      CrimpConfiguration.where(tool_id: row["tool_id"], custom_id: row["custom_id"], part_id: row["part_id"], wire_group_name: row["wire_group_name"], cross_section: row["cross_section"]).blank?
                    CrimpConfiguration.create(row.except("ID", "operator"))
                  end
                end

              end
            end
            msg.result = true
            msg.content = "ISO标准 上传成功"
          rescue => e
            puts e.backtrace
            msg.result = false
            msg.content = e.message
          end
        else
          msg.result = false
          msg.content = validate_msg.content
        end
        msg
      end


      def self.validate_import file
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
              row[k]=row[k].sub(/\.0/, '') if k=='part_id' || k=='custom_id' || k=='tool_id'
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
        msg=Message.new(contents: [])

        unless row["tool_id"].blank?
          unless tool=Tool.find_by_nr(row["tool_id"])
            msg.contents<<"Tool:#{row["tool_id"]}不存在"
          end
        end

        unless part=Part.find_by_nr(row["part_id"])
          msg.contents<<"Part:#{row["part_id"]}不存在"
        end

        unless msg.result=(msg.contents.size==0)
          msg.content=msg.contents.join('/')
        end
        return msg
      end

    end
  end
end
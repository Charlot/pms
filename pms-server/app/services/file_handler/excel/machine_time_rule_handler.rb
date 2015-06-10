module FileHandler
  module Excel
    class MachineTimeRuleHandler<Base
      HEADERS=[
          'OEE','Machine Type','Min Length','Max Length','Time'
      ]

      def self.import(file)
        msg = Message.new
        book = Roo::Excelx.new file.full_path
        book.default_sheet = book.sheets.first

        validate_msg = validate_import(file)
        if validate_msg.result
          #validate file
          begin
            MachineTimeRule.transaction do
              2.upto(book.last_row) do |line|
                row = {}
                HEADERS.each_with_index do |k, i|
                  row[k] = book.cell(line, i+1).to_s.strip
                end
                puts row['Time']
                oee = OeeCode.find_by_nr(row['OEE'])
                machine_type = MachineType.find_by_nr(row['Machine Type'])
                min_length = row['Min Length'].to_f
                max_length = row['Max Length'].to_f

                rule = MachineTimeRule.where({oee_code_id: oee.id,machine_type_id: machine_type.id,min_length: min_length,length: max_length}).first
                if rule
                  #update
                  rule.update(time:row['Time'].to_f)
                else
                  #create
                  rule = MachineTimeRule.create({oee_code_id:oee.id,machine_type_id:machine_type.id,min_length:min_length,length: max_length,time:row['Time'].to_f})
                end
              end
              end
            msg.result = true
            msg.content = "导入全自动工时成功"
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
        msg = Message.new(contents: [])

        oee = OeeCode.find_by_nr(row['OEE'])
        unless oee
          msg.contents << "OEE:#{row['OEE']} not found!"
        end

        machine_type = MachineType.find_by_nr(row['Machine Type'])
        unless machine_type
          msg.contents << "Machine Type:#{row['Machine Type']} not found!"
        end

        unless row['Min Length'].to_f > 0
          msg.contents << "Min Length: #{row['Min Length']} should not be 0!"
        end

        unless row['Max Length'].to_f > 0
          msg.contents << "Max Length: #{row['Max Length']} should not be 0!"
        end

        unless msg.result=(msg.contents.size==0)
          msg.content=msg.contents.join('/')
        end
        msg
      end
    end
  end
end
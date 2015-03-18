require 'csv'
module FileHandler
  module Csv
    class KanbanHandler<Base
      IMPORT_HEADERS=['Quantity','Safety Stock','Copies','Remark',
                      'Wire Nr','Product Nr','Type','Wire Length','Bundle',
      'Source Warehouse','Source Storage','Destination Warehouse','Destination Storage']
      INVALID_CSV_HEADERS=IMPORT_HEADERS<<'Error MSG'

      def self.import(file)
        #TODO Test import kanban
        msg = Message.new
        begin
          validate_msg = validate_import(file)
          if validate_msg.result
            Kanban.transaction do
              CSV.foreach(file.file_path,headers: file.headers,col_sep: file.col_sep,encoding: file.encoding) do |row|
                part = Part.find_by_nr(row['Wore Nr'])
                product = Part.find_by_nr(row['Product Nr'])

                kanban = Kanban.new({quantity:row['Quantity'],safety_stock:row['Safety Stock'],copies:row['Copies'],remark:row['Remark'],
                                    part_id:part.id,product_id:product.id,type:row['Type'],wire_length:row['Wire Length'],bundle:row['Bundle'],
                                    source_warehouse:row['Source Warehouse'],source_storage:row['Source Storage'],des_warehouse:row['Destination Warehouse'],
                                    des_storage:row['Destination Storage']})
                kanban.save
              end
            end
            msg.result = true
            msg.content = 'Kanban 上传成共'
          else
            msg.result = false
            msg.content = validate_msg.content
          end
        rescue => e
          puts e.backtrace
          msg.content = e.message
        end
        return msg
      end

      def self.validate_import(file)
        tmp_file=full_tmp_path(file.file_name)
        msg=Message.new(result: true)
        CSV.open(tmp_file, 'wb', write_headers: true,
                 headers: INVALID_CSV_HEADERS, col_sep: file.col_sep, encoding: file.encoding) do |csv|
          CSV.foreach(file.file_path, headers: file.headers, col_sep: file.col_sep, encoding: file.encoding) do |row|
            puts "validate row"
            if mmsg.result
              csv<<row.fields
            else
              if msg.result
                msg.result=false
                msg.content = "请下载错误文件<a href='/files/#{Base64.urlsafe_encode64(tmp_file)}'>#{::File.basename(tmp_file)}</a>"
              end
              csv<<(row.fields<<mmsg.content)
            end
          end
        end
        return msg
      end

      def self.validate_row(row)
        msg = Message.new({result:true})
        #TODO Validate kanban
        return msg
      end
    end
  end
end
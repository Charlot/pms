require 'csv'
module FileHandler
  module Csv
    class PartBomHandler<Base
      IMPORT_HEADERS=['Part Nr', 'Component Nr', 'Quantity']
      INVALID_CSV_HEADERS=IMPORT_HEADERS<<'Error MSG'
      # import bom by file
      def self.import(file)
        msg=Message.new
        begin
          validate_msg=validate_import(file)
          puts '00000000000000000'
          puts validate_msg.to_json
          if validate_msg.result
            PartBom.transaction do
              CSV.foreach(file.file_path, headers: file.headers, col_sep: file.col_sep, encoding: file.encoding) do |row|
                row.strip
                root=Part.find_by_nr(row['Part Nr'])
                node=Part.find_by_nr(row['Component Nr'])
                unless pm=root.part_boms.where(bom_item_id: node.id).first
                  root.part_boms.create(bom_item_id: node.id, quantity: row['Quantity'])
                else
                  pm.update_attributes(quantity: row['Quantity'])
                end
              end
            end
            msg.result=true
            msg.content='Bom 上传成功！'
          else
            msg.result =false
            msg.content=validate_msg.content
          end
        rescue => e
          puts e.backtrace
          msg.content = e.message
        end
        puts msg.to_json
        return msg
      end

      def self.validate_import(file)
        tmp_file=full_tmp_path(file.file_name)
        msg=Message.new(result: true)
        CSV.open(tmp_file, 'wb', write_headers: true,
                 headers: INVALID_CSV_HEADERS, col_sep: file.col_sep, encoding: file.encoding) do |csv|
          CSV.foreach(file.file_path, headers: file.headers, col_sep: file.col_sep, encoding: file.encoding) do |row|
            mmsg=validate_row(row)
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
        msg=Message.new(contents: [])
        unless root=Part.find_by_nr(row['Part Nr'])
          msg.contents<<"Part Nr:#{row['Part Nr']}不存在"
        end

        unless node=Part.find_by_nr(row['Component Nr'])
          msg.contents<<"Component Nr:#{row['Component Nr']}不存在"
        end

        # if root && node && (root.part_boms(bom_item_id: node.id))
        #   msg.contents<<"Component Nr:#{row['Component Nr']}已存在BOM中"
        # end

        unless msg.result=(msg.contents.size==0)
          msg.content=msg.contents.join('/')
        end
        return msg
      end
    end
  end
end
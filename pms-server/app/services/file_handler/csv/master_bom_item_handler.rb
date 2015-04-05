require 'csv'
module FileHandler
  module Csv
    class MasterBomItemHandler<Base
      IMPORT_HEADERS=['Part No.', 'Component P/N', 'Material Qty Per Harness', 'Dep', 'Delete']
      INVALID_CSV_HEADERS=IMPORT_HEADERS<<'Error MSG'

      def self.import(file)
        msg = Message.new
        begin
          validate_msg = validate_import(file)
          if validate_msg.result
            MasterBomItem.transaction do
              CSV.foreach(file.file_path, headers: file.headers, col_sep: file.col_sep, encoding: file.encoding) do |row|
                row.strip
                product=Part.find_by_nr(row['Part No.'])
                bom_item= Part.find_by_nr(row['Component P/N'])
                department= Department.find_by_code(row['Dep'])

                if item=MasterBomItem.where(product_id: product.id, bom_item_id: bom_item.id, department_id: department.id).first
                  if row['Delete'].to_i==1
                    item.destroy
                  end
                else
                  MasterBomItem.create(product_id: product.id,
                                       bom_item_id: bom_item.id,
                                       qty: row['Material Qty Per Harness'],
                                       department_id: department.id)
                end
              end
            end
            msg.result = true
            msg.content = 'MasterBOM 上传成共'
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
            row_valid_msg = validate_row(row)
            if row_valid_msg.result
              csv<<row.fields
            else
              if msg.result
                msg.result=false
                msg.content = "请下载错误文件<a href='/files/#{Base64.urlsafe_encode64(tmp_file)}'>#{::File.basename(tmp_file)}</a>"
              end
              csv<<(row.fields<<row_valid_msg.content)
            end
          end
        end
        return msg
      end

      def self.validate_row(row)
        msg=Message.new(contents: [])
        unless Part.find_by_nr(row['Part No.'])
          msg.contents<<"Part No.#{row['Part No.']} 不存在"
        end

        unless Part.find_by_nr(row['Component P/N'])
          msg.contents<<"Component P/N #{row['Component P/N']} 不存在"
        end

        # unless product.nil? || component.nil?
        #   msg.contents<<"Part No.#{row['Part No.']}  和 Component P/N #{row['Component P/N']} 已经组成BOM"
        # end

        unless Department.find_by_code(row['Dep'])
          msg.contents<<"Department:#{row['Dep']} 不存在"
        end

        unless msg.result=(msg.contents.size==0)
          msg.content=msg.contents.join('/')
        end
        return msg
      end
    end
  end
end

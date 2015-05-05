require 'csv'
module FileHandler
  module Csv
    class MasterBomItemHandler<Base
      IMPORT_HEADERS=['Part No.', 'Component P/N', 'Material Qty Per Harness', 'Dep', 'Delete']
      INVALID_CSV_HEADERS=IMPORT_HEADERS<<'Error MS'

      TRANSPORT_HEADERS=['Part No.', 'Qty']
      TRANSPORT_SUCCEED_HEADERS=['Component P/N', 'Dep', 'Total Qty']
      INVALID_TRANSPORT_HEADERS=TRANSPORT_HEADERS<<'Error MS'

      def self.import(file)
        msg = Message.new
        begin
          validate_msg = validate_import(file)
          if validate_msg.result
            MasterBomItem.transaction do
              CSV.foreach(file.file_path, headers: file.headers, col_sep: ';', encoding: file.encoding) do |row|
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

      def self.transport(file)
        msg = Message.new
        begin
          validate_msg = validate_transport(file)
          transport_file=full_tmp_path(file.file_name)
          if validate_msg.result
            transport_result={}
            MasterBomItem.transaction do
              # get order product
              product_qty={}
              CSV.foreach(file.file_path, headers: file.headers, col_sep: ';', encoding: file.encoding) do |row|
                row.strip
                product=Part.find_by_nr(row['Part No.'])
                qty=row['Qty'].to_i
                key=product.id.to_s
                if product_qty.has_key?(key)
                  product_qty[key]+=qty
                else
                  product_qty[key]=qty
                end
              end

              # add order part item
              product_qty.keys.each do |product_id|
                MasterBomItem.where(product_id: product_id).each do |item|
                  key="#{item.bom_item_id}:#{item.department_id}"
                  if transport_result.has_key?(key)
                    transport_result[key]+=item.qty*product_qty[item.product_id.to_s]
                  else
                    transport_result[key]=item.qty*product_qty[item.product_id.to_s]
                  end
                end
              end

              #write csv
              CSV.open(transport_file, 'wb', write_headers: true,
                       headers: TRANSPORT_SUCCEED_HEADERS, col_sep: ';', encoding: file.encoding) do |csv|
                transport_result.keys.each do |key|
                  p, d=key.split(':')
                  csv<<[Part.find_by_id(p).nr, Department.find_by_id(d).name, transport_result[key]]
                end
              end
            end
            msg.result = true
            msg.content = "请下载文成功文件<a href='/files/#{Base64.urlsafe_encode64(transport_file)}'>#{::File.basename(transport_file)}</a>"

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
                 headers: INVALID_CSV_HEADERS, col_sep: ';', encoding: file.encoding) do |csv|
          CSV.foreach(file.file_path, headers: file.headers, col_sep: ';', encoding: file.encoding) do |row|
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
          #msg.contents<<"Part No.#{row['Part No.']} 不存在.
          Part.create(nr: row['Part No.'], type: PartType::PRODUCT, description: '导入bom时建立')
        end

        unless Part.find_by_nr(row['Component P/N'])
          msg.contents<<"Component P/N #{row['Component P/N']} 不存在"
        end

        unless Department.find_by_code(row['Dep'])
          msg.contents<<"Department:#{row['Dep']} 不存在"
        end

        unless msg.result=(msg.contents.size==0)
          msg.content=msg.contents.join('/')
        end
        return msg
      end

      def self.validate_transport(file)
        tmp_file=full_tmp_path(file.file_name)
        msg=Message.new(result: true)
        CSV.open(tmp_file, 'wb', write_headers: true,
                 headers: INVALID_TRANSPORT_HEADERS, col_sep: file.col_sep, encoding: file.encoding) do |csv|
          CSV.foreach(file.file_path, headers: file.headers, col_sep: file.col_sep, encoding: file.encoding) do |row|
            row_valid_msg = validate_transport_row(row)
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

      def self.validate_transport_row(row)
        msg=Message.new(contents: [])
        unless Part.find_by_nr(row['Part No.'])
          msg.contents<<"Part No.#{row['Part No.']} 不存在"
        end

        unless msg.result=(msg.contents.size==0)
          msg.content=msg.contents.join('/')
        end
        return msg
      end
    end
  end
end
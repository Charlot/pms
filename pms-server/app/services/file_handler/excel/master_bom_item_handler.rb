module FileHandler
  module Excel
    class MasterBomItemHandler<Base
      HEADERS=[
          'Part No.', 'Component P/N', 'Material Qty Per Harness', 'Dep', 'Project Name', 'Delete'
      ]
      EXPORT_HEADERS=['Part No.', 'Component P/N', 'Material Qty Per Harness', 'Dep', 'Project Name', 'Delete', 'Round Qty(导入时,这一列需删除)']
      DELETE_HEADERS=['Part No.', 'Component P/N', 'Dep', 'Project Name']
      TRANSPORT_HEADERS=['Part No.', 'Qty']
      TRANSPORT_SUCCEED_HEADERS=['Component P/N', 'Dep', 'Total Qty', 'Mark']
      TRANSPORT_SUCCEED_TOTAL_HEADERS=['Component P/N', 'Total Qty', 'Mark']
      #INVALID_TRANSPORT_HEADERS=TRANSPORT_HEADERS<<'Error MS'

      def self.import(file)
        msg = Message.new
        book = Roo::Excelx.new file.full_path
        book.default_sheet = book.sheets.first

        validate_msg = validate_import(file)
        if validate_msg.result
          #validate file
          begin
            MasterBomItem.transaction do
              2.upto(book.last_row) do |line|
                row = {}
                HEADERS.each_with_index do |k, i|
                  row[k] = book.cell(line, i+1).to_s.strip
                  row[k]=row[k].sub(/\.0/, '') if k=='Part No.' || k=='Component P/N'
                end

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
                                       department_id: department.id,
                                       project_name: row['Project Name'])
                end

              end
            end
            msg.result = true
            msg.content = "MasterBOM 上传成功"
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


      def self.import_delete(file)
        msg = Message.new
        book = Roo::Excelx.new file.full_path
        book.default_sheet = book.sheets.first
        begin
          MasterBomItem.transaction do
            validate_msg = validate_delete_import(file)
            if validate_msg.result
              #validate file

              2.upto(book.last_row) do |line|
                row = {}
                DELETE_HEADERS.each_with_index do |k, i|
                  row[k] = book.cell(line, i+1).to_s.strip
                  row[k]=row[k].sub(/\.0/, '') if k=='Part No.' || k=='Component P/N'
                end

                query=MasterBomItem
                if row['Part No.'].present? && (product=Part.find_by_nr(row['Part No.']))
                  query=query.where(product_id: product.id)
                end

                if row['Component P/N'].present? && (bom_item= Part.find_by_nr(row['Component P/N']))
                  query=query.where(bom_item_id: bom_item.id)
                end

                if row['Dep'].present? && (department= Department.find_by_code(row['Dep']))
                  query=query.where(department_id: department.id)
                end

                if row['Project Name'].present?
                  query=query.where(project_name: row['Project Name'])
                end

                query.destroy_all

              end
              msg.result = true
              msg.content = "MasterBOM 删除成功"
            else
              msg.content = validate_msg.content
            end
          end
        rescue => e
          msg.result = false
          msg.content = e.message
        end
        msg
      end

      def self.export(params)
        msg = Message.new
        begin
          tmp_file = MasterBomItemHandler.full_tmp_path('master_bom.xlsx')
          p = Axlsx::Package.new
          p.workbook.add_worksheet(:name => "Basic Worksheet") do |sheet|
            sheet.add_row EXPORT_HEADERS
            MasterBomItem.search(params).all.each do |item|
              sheet.add_row [
                                item.product_nr,
                                item.bom_item_nr,
                                item.qty,
                                item.department_code,
                                item.project_name,
                                '0',
                                item.round_qty
                            ], types: [:string, :string, :string, :string, :string, :string, :string]
            end
          end
          p.use_shared_strings = true
          p.serialize(tmp_file)

          msg.result =true
          msg.content =tmp_file
        rescue => e
          msg.content =e.message
        end
        msg
      end


      def self.export_uniq_product
        msg = Message.new
        begin
          tmp_file = MasterBomItemHandler.full_tmp_path('master_bom_uniq_product.xlsx')
          p = Axlsx::Package.new
          p.workbook.add_worksheet(:name => "Basic Worksheet") do |sheet|
            sheet.add_row %w(零件号 客户号)
            Part.joins(:product_master_bom_items).uniq.each do |item|
              sheet.add_row [
                                item.nr,
                                item.custom_nr
                            ], types: [:string, :string]
            end
          end
          p.use_shared_strings = true
          p.serialize(tmp_file)

          msg.result =true
          msg.content =tmp_file
        rescue => e
          msg.content =e.message
        end
        msg
      end


      def self.transport(file)
        msg = Message.new
        begin
          validate_msg = validate_transport(file)
          transport_file=full_tmp_path(file.original_name)
          if validate_msg.result
            #  if true
            MasterBomItem.transaction do
              # get order product
              product_qty={}
              total_transport_result={}
              transport_result={}
              book = Roo::Excelx.new file.full_path
              book.default_sheet = book.sheets.first
              #validate file
              2.upto(book.last_row) do |line|
                row = {}
                TRANSPORT_HEADERS.each_with_index do |k, i|
                  row[k] = book.cell(line, i+1).to_s.strip
                  row[k]=row[k].sub(/\.0/, '') if k=='Part No.'
                end
                product=Part.find_by_nr(row['Part No.'])
                if product
                  qty=row['Qty'].to_i
                  key=product.id.to_s
                  if product_qty.has_key?(key)
                    product_qty[key]+=qty
                  else
                    product_qty[key]=qty
                  end
                end
              end

              puts "------------------#{product_qty.to_json}".red

              # add order part item
              product_qty.keys.each do |product_id|
                MasterBomItem.where(product_id: product_id).each do |item|
                  total_key="#{item.bom_item_id}"
                  key="#{item.bom_item_id}:#{item.department_id}"

                  rqty=item.round_qty
                  # if Setting.bom_translate_round? && item.qty.present?
                  #   if item.qty.to_f.to_s.split(',').last.length>=Setting.bom_translate_round_length.to_i
                  #     rqty=item.qty.round(Setting.bom_translate_round_value)
                  #   end
                  # end


                  raise("#{Part.find(product_id).nr} bom ，请更新后分解") if item.qty.nil?
                  if total_transport_result.has_key?(total_key)
                    total_transport_result[total_key]+=rqty*product_qty[item.product_id.to_s]
                  else
                    total_transport_result[total_key]=rqty*product_qty[item.product_id.to_s]
                  end

                  if transport_result.has_key?(key)
                    transport_result[key]+=rqty*product_qty[item.product_id.to_s]
                  else
                    transport_result[key]=rqty*product_qty[item.product_id.to_s]
                  end

                end
              end

              puts "------------------#{total_transport_result.to_json}".blue
              puts "------------------#{transport_result.to_json}".yellow

              package = Axlsx::Package.new
              package.workbook.add_worksheet(:name => "分解汇总") do |sheet|
                sheet.add_row TRANSPORT_SUCCEED_TOTAL_HEADERS
                total_transport_result.keys.each do |key|
                  if part=Part.find_by_id(key)
                    sheet.add_row [part.nr,
                                   total_transport_result[key], part.material_mark], types: [:string, :float, :string]
                  end
                end
              end

              package.workbook.add_worksheet(:name => "分解明细") do |sheet|
                sheet.add_row TRANSPORT_SUCCEED_HEADERS
                transport_result.keys.each do |key|
                  p, d=key.split(':')
                  if part=Part.find_by_id(p)
                    sheet.add_row [part.nr,
                                   Department.find_by_id(d).name,
                                   transport_result[key], part.material_mark], types: [:string, :string, :float, :string]
                  end
                end
              end
              package.use_shared_strings = true
              package.serialize(transport_file)

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
              row[k]=row[k].sub(/\.0/, '') if k=='Part No.' || k=='Component P/N'
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

      def self.validate_delete_import file
        tmp_file=full_tmp_path(file.original_name)
        msg = Message.new(result: true)
        book = Roo::Excelx.new file.full_path
        book.default_sheet = book.sheets.first

        p = Axlsx::Package.new
        p.workbook.add_worksheet(:name => "Basic Worksheet") do |sheet|
          sheet.add_row DELETE_HEADERS+['Error Msg']
          #validate file
          2.upto(book.last_row) do |line|
            row = {}
            DELETE_HEADERS.each_with_index do |k, i|
              row[k] = book.cell(line, i+1).to_s.strip
              row[k]=row[k].sub(/\.0/, '') if k=='Part No.' || k=='Component P/N'
            end

            mssg = validate_delete_row(row, line)
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

      def self.validate_delete_row(row, line)
        msg=Message.new(contents: [])
        unless Part.find_by_nr(row['Part No.'])
          msg.contents<<"Part No.#{row['Part No.']} 不存在."
        end

        unless Part.find_by_nr(row['Component P/N'])
          msg.contents<<"Component P/N #{row['Component P/N']} 不存在"
        end if row['Component P/N'].present?

        unless Department.find_by_code(row['Dep'])
          msg.contents<<"Department:#{row['Dep']} 不存在"
        end if row['Dep'].present?

        unless msg.result=(msg.contents.size==0)
          msg.content=msg.contents.join('/')
        end
        return msg
      end


      def self.validate_transport(file)
        tmp_file=full_tmp_path(file.original_name)
        msg=Message.new(result: true)

        book = Roo::Excelx.new file.full_path
        book.default_sheet = book.sheets.first

        p = Axlsx::Package.new
        p.workbook.add_worksheet(:name => "Basic Worksheet") do |sheet|
          sheet.add_row TRANSPORT_HEADERS+['Error Msg']
          #validate file
          2.upto(book.last_row) do |line|
            row = {}
            TRANSPORT_HEADERS.each_with_index do |k, i|
              row[k] = book.cell(line, i+1).to_s.strip
              row[k]=row[k].sub(/\.0/, '') if k=='Part No.'
            end
            mssg = validate_transport_row(row)
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

      def self.validate_transport_row(row)
        msg=Message.new(contents: [])
        unless part=Part.find_by_nr(row['Part No.'])
          msg.contents<<"Part No.#{row['Part No.']} 不存在"
        else
          if part.product_master_bom_items.count==0
            msg.contents<<"不存在BOM,请维护"
          end
        end

        if row['Qty'].blank?
          msg.contents<<"Qty 未填"
        end

        unless msg.result=(msg.contents.size==0)
          msg.content=msg.contents.join('/')
        end
        return msg
      end

    end
  end
end

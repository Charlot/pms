module FileHandler
  module Excel
    class KanbanHandler<Base
      HEADERS=[
          'Nr', 'Quantity', 'Safety Stock', 'Copies',
          'Remark', 'Remark2', 'Wire Nr', 'Product Nr', 'Type',
          'Bundle', 'Destination Warehouse',
          'Destination Storage', 'Process List', 'State', 'Operator'
      ]

      WHITE_HEADERS=['Nr', 'Quantity', 'Safety Stock', 'Copies', 'Task Time',
                     'Remark', 'Remark2', 'Wire Nr', 'Product Nr', 'Type',
                     'Bundle', 'Destination Warehouse',
                     'Destination Storage', 'Process List', 'Row Wire Nr', 'Diameter', 'Length', 'T1', 'T2', 'S1', 'S2', 'State']

      def self.import_update_quantity(file)
        msg = Message.new(contents: [])

        header = ['Kanban Nr', 'Wire Nr', 'Product Nr', 'Quantity', 'Bundle']

        book = Roo::Excelx.new file
        book.default_sheet = book.sheets.first

        2.upto(book.last_row) do |line|
          row = {}
          header.each_with_index do |k, i|
            row[k] = book.cell(line, i+1).to_s.strip # Strip
          end

          kanban = nil

          if row['Kanban Nr'].present?
            kanban=Kanban.find_by_nr(row['Kanban Nr'])
            next unless kanban
          else
            product = Part.where({nr: row['Product Nr'], type: PartType::PRODUCT}).first
            if product.nil?
              msg.contents << "Row #{line}: 总成号:#{row['Product Nr']}未找到!"
              puts "总成号未找到"
              next
            end

            wire = Part.find_by_nr("#{product.nr}_#{row['Wire Nr']}")

            if wire.nil?
              msg.contents << "Row #{line}: 线号:#{row['Wire Nr']}未找到!"
              puts "线号未找到"
              next
            end

            pe=ProcessEntity.joins(custom_values: :custom_field).joins(:kanbans).where(
                {product_id: product.id, custom_fields: {name: "default_wire_nr"}, custom_values: {value: wire.id}, kanbans: {ktype: KanbanType::WHITE}}
            ).first

            if pe && (kanban=pe.kanbans.where(ktype: KanbanType::WHITE).first)
              # kanban = pe.kanbans.where(ktype: KanbanType::WHITE).first
            else
              next
              # msg.contents<< "Row:#{line}步骤不存在！或步骤不消耗零件!"
            end
          end
          kanban.update({quantity: row['Quantity'], bundle: row['Bundle']})
        end

        msg.result = true
        msg.content = "更新成功!"
        msg
      end

      def self.import_lock_unlock(file, state)
        msg = Message.new(contents: [])

        header = ['Kanban Nr']

        book = Roo::Excelx.new file
        book.default_sheet = book.sheets.first

        2.upto(book.last_row) do |line|
          row = {}
          header.each_with_index do |k, i|
            row[k] = book.cell(line, i+1).to_s.strip # Strip
          end

          kanban = nil

          if row['Kanban Nr'].present?
            kanban=Kanban.find_by_nr(row['Kanban Nr'])
            next unless kanban
          end
          kanban.without_versioning do
            kanban.update(state: state)
          end
        end

        msg.result = true
        msg.content = '处理成功!'
        msg
      end

      def self.export q = nil
        msg = Message.new
        begin
          tmp_file = full_export_path("(#{q})Kanban.xlsx") unless tmp_file

          p = Axlsx::Package.new
          p.workbook.add_worksheet(:name => "Basic Worksheet") do |sheet|
            sheet.add_row HEADERS
            kanbans = []
            if q.nil?
              # kanbans= Kanban.where.not(state: KanbanState::DELETED).all
              kanbans= Kanban.all
            else
              kanbans = Kanban.search_for(q).all
              # kanbans = Kanban.search_for(q).select { |k| [KanbanState::INIT, KanbanState::RELEASED, KanbanState::LOCKED].include? k.state }
            end
            kanbans.each do |k|
              sheet.add_row [
                                k.nr,
                                k.quantity,
                                k.safety_stock,
                                k.copies,
                                k.remark,
                                k.remark2,
                                k.wire_nr,
                                k.product_nr,
                                k.ktype,
                                k.bundle,
                                k.des_warehouse,
                                k.des_storage,
                                k.process_list,
                                KanbanState.display(k.state),
                                'update'
                            ], types: [:string, nil, nil, nil, nil, :string, :string]
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

      def self.export_white
        msg = Message.new
        begin
          tmp_file = full_export_path('WirteKanban.xlsx') unless tmp_file

          p = Axlsx::Package.new
          p.workbook.add_worksheet(name: 'Basic Worksheet') do |sheet|
            sheet.add_row WHITE_HEADERS
            kanbans =Kanban.where(ktype: KanbanType::WHITE)

            kanbans.each do |k|
              process_entity=k.process_entities.first
              next if process_entity.blank?
              wire=Part.find_by_id(process_entity.value_wire_nr)
              t1=Part.find_by_id(process_entity.value_t1)
              t2=Part.find_by_id(process_entity.value_t2)

              s1=Part.find_by_id(process_entity.value_s1)
              s2=Part.find_by_id(process_entity.value_s2)

              sheet.add_row [
                                k.nr,
                                k.quantity,
                                k.safety_stock,
                                k.copies,
                                k.task_time,
                                k.remark,
                                k.remark2,
                                k.wire_nr,
                                k.product_nr,
                                k.ktype,
                                k.bundle,
                                k.des_warehouse,
                                k.des_storage,
                                k.process_list,
                                wire.nil? ? '' : wire.nr,
                                wire.nil? ? '' : wire.cross_section,
                                process_entity.value_wire_qty_factor,
                                t1.nil? ? '' : t1.nr,
                                t2.nil? ? '' : t2.nr,
                                s1.nil? ? '' : s1.nr,
                                s2.nil? ? '' : s2.nr,
                                KanbanState.display(k.state)
                            ], types: [:string, nil, nil, nil, nil, :string, :string, :string, :string, :string, :string, :string, :string, :string, :string, :string, :string, :string, :string, :string]
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


      def self.export_simple(q)
        msg = Message.new
        begin
          tmp_file = full_export_path("看板条码信息.xlsx") unless tmp_file

          p = Axlsx::Package.new
          p.workbook.add_worksheet(:name => "Basic Worksheet") do |sheet|
            sheet.add_row ['看板号', '新条码', '旧条码', '卡量', '捆扎量',
                           '总成号', '半成品线号',
                           '送料位置', '类型']
            kanbans = []
            if q.nil?
              kanbans= Kanban.all
            else
              kanbans = Kanban.search_for(q).all
            end
            kanbans.each do |k|
              sheet.add_row [
                                k.nr,
                                k.printed_2DCode,
                                k.old_printed_2DCode,
                                k.quantity,
                                k.bundle,
                                k.product_nr,
                                k.wire_nr,
                                k.des_storage,
                                KanbanType.display(k.ktype)
                            ], types: [:string, :string, :string, :string, :string, :string, :string, :string, :string, :string]
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


      def self.export_items_count(q)
        msg = Message.new
        begin
          tmp_file = full_export_path("看板投卡次数.xlsx") unless tmp_file

          p = Axlsx::Package.new
          p.workbook.add_worksheet(:name => "Basic Worksheet") do |sheet|
            sheet.add_row ['序号', '看板号', '看板类型', '状态', '投卡次数']
            kanbans = []
            if q.nil?
              kanbans= Kanban
            else
              kanbans = Kanban.search_for(q)
            end


            kanbans.unscoped.all.each_with_index do |k, i|
              sheet.add_row [
                                i+1,
                                k.nr,
                                KanbanType.display(k.ktype),
                                KanbanState.display(k.state),
                                k.production_order_items.unscoped.where(kanban_id: k.id).count
                            ], types: [:string, :string, :string, :string]
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

      def self.import_scan(file, type=KanbanType::WHITE)
        msg = Message.new(contents: [])
        handler_file=full_tmp_path("#{KanbanType.display(type)}投卡处理结果.xlsx")

        begin
          header = ['Kanban Nr', 'Wire Nr', 'Product Nr']

          book = Roo::Excelx.new file
          book.default_sheet = book.sheets.first

          package=Axlsx::Package.new
          package.workbook.add_worksheet(name: 'Kanban Sheet') do |sheet|
            sheet.add_row header+['看板号', 'Msg']
            ProductionOrderItem.transaction do
              2.upto(book.last_row) do |line|
                row = {}
                header.each_with_index do |k, i|
                  row[k] = book.cell(line, i+1).to_s.strip # Strip
                end
                handler_msg=nil
                kanban = Kanban.find_by_nr_or_id(row['Kanban Nr'])

                if kanban.nil?
                  handler_msg='看板不存在'
                elsif type!=kanban.ktype
                  handler_msg="此卡为:#{KanbanType.display(kanban.ktype)},请投#{KanbanType.display(type)}"
                elsif kanban.quantity <= 0
                  handler_msg='看板量不大于0'
                elsif kanban.state != KanbanState::RELEASED
                  handler_msg='看板未发布'
                elsif kanban.can_put_to_produce?
                  if kanban.process_entities.count>0
                    if kanban.generate_produce_item
                      handler_msg='投卡成功!'
                    end
                  else
                    handler_msg='没有步骤，请联系AV'
                  end
                else
                  handler_msg='已投卡,不可重复投卡'
                end
                sheet.add_row row.values+["#{kanban.nil? ? '' : kanban.nr}", handler_msg],
                              types: [:string, :string, :string, :string, :string]
              end
            end
          end

          package.use_shared_strings = true
          package.serialize(handler_file)

          msg.result=true
          msg.content = "请下载处理后文件<a href='/files/#{Base64.urlsafe_encode64(handler_file)}'>#{::File.basename(handler_file)}</a>"
        rescue => e
          msg.result =false
          msg.content =e.message
        end
        msg
      end


      def self.import_finish_scan file, type
        msg = Message.new(contents: [], result: true)
        handler_file=full_tmp_path("#{KanbanType.display(type)}销卡处理结果.xlsx")

        header = ['看板卡', '时间', '员工', '数量']

        book = Roo::Excelx.new file
        book.default_sheet = book.sheets.first
        ProductionOrderItem.transaction do
          production_order_handler=ProductionOrderHandler.new(desc: '兰卡销卡')
          package=Axlsx::Package.new
          package.workbook.add_worksheet(name: 'Kanban Sheet') do |sheet|
            sheet.add_row header+['看板号', 'Msg']
            2.upto(book.last_row) do |line|
              row = {}
              header.each_with_index do |k, i|
                row[k] = book.cell(line, i+1).to_s.strip # Strip
              end
              puts "#{row.to_json}"
              kanban = nil
              production_order_handler_item=ProductionOrderHandlerItem.new(
                  desc: '兰卡销卡',
                  kanban_code: row['看板卡'],
                  qty: row['数量'].present? ? row['数量'] : nil,
                  item_terminated_at: row['时间'].to_time.utc,
                  handler_user: row['员工']
              )
              puts "#{row.to_json}:#{production_order_handler_item.to_json}"

              production_order_handler.production_order_handler_items<<production_order_handler_item

              if row['看板卡'].present?
                kanban = Kanban.find_by_nr_or_id(row['看板卡'])
              end

              handler_msg=nil
              if kanban.nil?
                handler_msg='看板不存在'
                msg.contents<<"Row:#{line}.#{row['看板卡'].to_s},看板不存在"
                production_order_handler_item.remark= msg.contents.join("</br>")
                production_order_handler_item.result=ProductionOrderHandlerItem::FAIL
              elsif type!=kanban.ktype
                handler_msg="此卡为:#{KanbanType.display(kanban.ktype)},请投#{KanbanType.display(type)}"
                msg.contents<<"Row:#{line}.#{row['看板卡'].to_s},看板不存在"
                production_order_handler_item.remark= msg.contents.join("</br>")
                production_order_handler_item.result=ProductionOrderHandlerItem::FAIL
              elsif kanban.not_in_produce?
                handler_msg='未投卡，不可销卡'
                msg.contents<<"Row:#{line}:#{kanban.nr},未投卡，不可销卡"
                production_order_handler_item.remark= msg.contents.join("</br>")
                production_order_handler_item.result=ProductionOrderHandlerItem::FAIL
                production_order_handler_item.kanban_nr=kanban.nr
                production_order_handler_item.kanban_id=kanban.id
              elsif kanban.terminate_produce_item(production_order_handler_item)
                handler_msg='销卡成功'
                production_order_handler_item.remark= msg.contents.join("</br>")
                production_order_handler_item.result=ProductionOrderHandlerItem::SUCCESS
                production_order_handler_item.kanban_nr=kanban.nr
                production_order_handler_item.kanban_id=kanban.id
              end
              sheet.add_row row.values+["#{kanban.nil? ? '' : kanban.nr}", handler_msg],
                            types: [:string, :string, :string, :string, :string, :string]
            end
          end

          production_order_handler.save
          package.use_shared_strings = true
          package.serialize(handler_file)

          msg.result=true
          msg.content = "请下载处理后文件<a href='/files/#{Base64.urlsafe_encode64(handler_file)}'>#{::File.basename(handler_file)}</a>"

        end

        msg
      end

      def self.transport(file)
        msg=Message.new

        book=Roo::Excelx.new file.full_path
        transport_file=full_tmp_path(file.original_name)
        header=['Kanban Nr', 'Qty']

        origin_header=['Kanban Nr', 'Qty', 'Kanban Id', 'Product Nr', 'WireNr', 'Routing', '单线用料', '看板用料']
        origin_rows=[]
        result_header=['Part', 'Qty', 'Mark']
        result_rows={}
        2.upto(book.last_row) do |line|
          origin_row=[]
          row={}
          header.each_with_index do |k, i|
            row[k]=book.cell(line, i+1).to_s.strip
            row[k]=row[k].sub(/\.0/, '') if k=='Kanban Nr'
            origin_row<<book.cell(line, i+1).to_s.strip
          end

          kanban=Kanban.find_by_nr_or_id(row['Kanban Nr'])
          if kanban
            if kanban.process_entities.first.nil?
              origin_row<<"看板：#{row['Kanban Nr']} 不存在步骤"
            else
              origin_row<<kanban.id
              origin_row<<kanban.product.nr
              origin_row<<kanban.kanban_part.nr
              origin_row<<kanban.process_list
              # single kanban material
              s_materials=[]
              # total kanban material
              t_materials=[]

              kanban.materials.each do |m|
                s_materials<<"#{m.nr}|#{m.quantity}"
                qty=BigDecimal.new(m.quantity.to_s)*(row['Qty'].to_f)
                t_materials<<"#{m.nr}|#{qty}"
                if result_rows.has_key?(m.nr)
                  result_rows[m.nr]+=qty
                else
                  result_rows[m.nr]=qty
                end
              end
              origin_row<<s_materials.join(',')
              origin_row<<t_materials.join(',')
            end
          else
            origin_row<<"看板：#{row['Kanban Nr']} 不存在"
          end
          origin_rows<<origin_row
        end

        package=Axlsx::Package.new
        package.workbook.add_worksheet(name: 'Kanban Sheet') do |sheet|
          sheet.add_row origin_header
          origin_rows.each do |origin_row|
            sheet.add_row origin_row, types: [:string, :string, :string, :string, :string, :string]
          end
        end

        package.workbook.add_worksheet(name: '汇总') do |sheet|
          sheet.add_row result_header
          result_rows.each do |k, v|
            sheet.add_row [k, v, Part.find_by_nr(k).material_mark], types: [:string, :string, :string]
          end
        end


        package.serialize(transport_file)

        msg.result=true
        msg.content = "请下载文成功文件<a href='/files/#{Base64.urlsafe_encode64(transport_file)}'>#{::File.basename(transport_file)}</a>"

        msg
      end

      def self.import file
        msg = Message.new
        book = Roo::Excelx.new file.full_path
        book.default_sheet = book.sheets.first

        validate_msg = validate_import(file)
        if validate_msg.result

          #validate file
          #begin
            Kanban.transaction do
              2.upto(book.last_row) do |line|
                row = {}
                HEADERS.each_with_index do |k, i|
                  row[k] = book.cell(line, i+1).to_s.strip
                end

                product = Part.find_by_nr(row['Product Nr'])
                # 这段代码后面可能需要重新修改，因为项目刚启动，频繁修改卡量
                # 所以写在这里
                if row['Quantity'].to_i < row['Bundle'].to_i
                  row['Bundle'] = row['Quantity']
                end


                if state=KanbanState.get_value_by_display(row['State'])
                  row['State']=state
                else
                  row['State']=KanbanState::RELEASED
                end

                params = {}
                HEADERS.each { |header|
                  unless (row[header].nil? || header_to_attr(header).nil?)
                    params[header_to_attr(header)] = row[header]
                  end
                }
                params[:product_id] = product.id

                case row['Operator']
                  when 'new', ''
                    kanban = Kanban.new(params)
                    process_nrs = row['Process List'].split(',')

                    kanban_process_entities = []
                    process_nrs.each_with_index { |pr, i|
                      pe = ProcessEntity.where({nr: pr, product_id: product.id}).first
                      kanban_process_entities << KanbanProcessEntity.new({process_entity_id: pe.id, position: i})
                    }
                    kanban.kanban_process_entities = kanban_process_entities
                    # kanban.state = KanbanState::RELEASED
                    kanban.save
                  when 'update'
                    kanban = Kanban.find_by_nr(row['Nr'])
                    kanban.update(params)
                    # 暴力法，一律删除然后重新创建
                    # kanban.kanban_process_entities.destroy_all
                    old_kpes=kanban.kanban_process_entities.pluck(:id)
                    process_nrs = row['Process List'].split(',')
                    # kanban_process_entities = []
                    process_nrs.each_with_index { |pr, i|
                      pe = ProcessEntity.where({nr: pr, product_id: product.id}).first
                      # kanban_process_entities << KanbanProcessEntity.new({process_entity_id: pe.id, position: i})
                      if kpe=kanban.kanban_process_entities.where(process_entity_id: pe.id).first
                        kpe.update(position: i)
                        old_kpes.delete(kpe.id)
                      else
                        kanban.kanban_process_entities << KanbanProcessEntity.new({process_entity_id: pe.id, position: i})
                      end
                    }
                    old_kpes.each do |i|
                      KanbanProcessEntity.find_by_id(i).destroy
                    end
                    #process_nrs = row['Process List'].split(',')
                    #kanban_process_entities = ProcessEntity.where({nr: process_nrs, product_id: product.id}).collect { |pe| KanbanProcessEntity.new({process_entity_id: pe.id}) }
                    # kanban.kanban_process_entities = kanban_process_entities
                    kanban.save
                  when 'delete'
                    kanban = Kanban.find_by_nr(row['Nr'])
                    kanban.destroy
                end
              end
            end
            msg.result = true
            msg.content = "导入看板成功"
          #rescue => e
           # puts e.backtrace
           # msg.result = false
           # msg.content = e.message
         # end
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
        raise('文件模版错误，请重新上传') unless book.cell(1, HEADERS.length)=='Operator'

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

      def self.validate_row row, line
        msg = Message.new(contents: [])

        product = Part.where({nr: row['Product Nr'], type: PartType::PRODUCT}).first

        case row['Operator']
          when 'delete'
            kanban = Kanban.find_by_nr(row['Nr'])
            unless kanban
              msg.contents << "Nr:#{row['Nr']},Kanban不存在"
            end
          when 'update'
            kanban = Kanban.find_by_nr(row['Nr'])
            unless kanban
              msg.contents << "Nr:#{row['Nr']},Kanban不存在"
            end
          when 'new', ''
            if row['Nr'].present?
              msg.contents << "Nr:#{row['Nr']},新建时，不能输入Nr"
            end
          else
            msg.contents << "Operator,#{row['Operator']},操作错误"
        end

        # 验证状态
        if row['State'].present?
          msg.contents << "State:#{row['State']} 状态不存在" unless KanbanState.get_value_by_display(row['State'])
        end

        # 验证总成号
        unless product
          msg.contents<<"Product Nr:#{row['Product Nr']},总成号不存在"
        end

        if product
          # 验证工艺
          process_nrs = row['Process List'].split(',').collect { |penr| penr.strip }
          process_entities = ProcessEntity.where({nr: process_nrs, product_id: product.id})
          nrs= process_nrs - process_entities.collect { |pe| pe.nr }
          unless nrs.count==0
            msg.contents << "Process List: #{nrs}，工艺不存在!"
          end
        end

        # 验证看板类型
        unless KanbanType.has_value?(row['Type'].to_i)
          msg.contents << "Type: #{row['Type']} 不正确"
        end

        unless msg.result=(msg.contents.size==0)
          msg.content=msg.contents.join('/')
        end
        msg
      end

      def self.header_to_attr header
        case header
          when "Nr"
            :nr
          when "Quantity"
            :quantity
          when "Safety Stock"
            :safety_stock
          when "Copies"
            :copies
          when "Remark"
            :remark
          when 'Remark2'
            :remark2
          when "Type"
            :ktype
          #when "Wire Length"
          #  :wire_length
          when "Bundle"
            :bundle
          when "Source Warehouse"
            :source_warehouse
          when "Source Storage"
            :source_storage
          when "Destination Warehouse"
            :des_warehouse
          when "Destination Storage"
            :des_storage
          when 'State'
            :state
          else
            nil
        end
      end
    end
  end
end

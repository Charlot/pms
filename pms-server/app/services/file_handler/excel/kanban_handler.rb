module FileHandler
  module Excel
    class KanbanHandler<Base
    	HEADERS=[
    		'Nr','Quantity','Safety Stock','Copies',
    		'Remark','Wire Nr','Product Nr','Type',
    		'Bundle','Source Warehouse','Source Storage','Destination Warehouse',
    		'Destination Storage','Process List','Operate'
    	]

      def self.export q = nil
        msg = Message.new
        begin
          tmp_file = full_tmp_path('kanbans.xlsx') unless tmp_file

          p = Axlsx::Package.new
          p.workbook.add_worksheet(:name => "Basic Worksheet") do |sheet|
            sheet.add_row HEADERS

            Kanban.search_for(q).each do |k|
              sheet.add_row [
                                k.nr,
                                k.quantity,
                                k.safety_stock,
                                k.copies,
                                k.remark,
                                k.wire_nr,
                                k.product_nr,
                                k.ktype,
                                k.bundle,
                                k.source_warehouse,
                                k.source_storage,
                                k.des_warehouse,
                                k.des_storage,
                                k.process_list
                            ]
            end

          end
          p.use_shared_strings = true
          p.serialize(tmp_file)

          msg.result =true
          msg.content =tmp_file
        rescue => e
          msg.content = e.message
        end
        msg
      end

      def self.import_scan file

        msg = Message.new(contents:[])

        header = ['Wire Nr','Product Nr']

        book = Roo::Excelx.new file
        book.default_sheet = book.sheets.first

        2.upto(book.last_row) do |line|
          params = {}
          header.each_with_index do |k,i|
            params[k] = book.cell(line,i+1)
          end

          product = Part.where({nr:params['Product Nr'],type:PartType::PRODUCT}).first
          if product.nil?
            msg.contents << "Row #{line}: 总成号:#{params['Product Nr']}未找到!"
            puts "总成号未找到"
            next
          end

          wire = Part.find_by_nr("#{product.nr}_#{params['Wire Nr']}")

          if wire.nil?
            msg.contents << "Row #{line}: 线号:#{params['Wire Nr']}未找到!"
            puts "线号未找到"
            next
          end

          pe = ProcessEntity.joins(custom_values: :custom_field).where(
              {product_id:product.id,custom_fields:{name:"default_wire_nr"},custom_values:{value:wire.id}}
          ).first

          kanban = pe.kanbans.first

          if kanban

            @kanban = kanban

            if @kanban.quantity <= 0
              next
            end
            if ProductionOrderItem.where(kanban_id: @kanban.id, state: ProductionOrderItemState::INIT).count > 0
              msg.contents<<"Row:#{line},已投卡"
              next
            end

            process_entity = @kanban.process_entities.first
            if process_entity && process_entity.process_parts.count > 0
              can_create = true
              parts = []
              process_entity.process_parts.each { |pe|
                part = pe.part
                # if (part.type == PartType::MATERIAL_TERMINAL) && (part.tool == nil)
                #   can_create = false
                # end
                if can_create #&& part.type == PartType::MATERIAL_TERMINAL
                  parts << part.nr
                end
              }

              # if process_entity.process_parts.select { |pe| pe.part.type == PartType::MATERIAL_TERMINAL }.count <= 0
              #   can_create = false
              # end

              if can_create
                unless (@order = ProductionOrderItem.create(kanban_id: @kanban.id, code: @kanban.printed_2DCode))
                  next
                end

                puts "新建订单成功：#{@kanban.nr},#{parts.join('-')}".green
              end
            else
              puts "步骤不存在！或步骤不消耗零件!".red
            end
          end
        end

        msg.result = true
        if msg.contents.count > 0
          msg.content = msg.contents.join(";")
        else
          msg.content = "投卡成功!"
        end
        msg
      end

    	def self.import file
        msg = Message.new
    		book = Roo::Excelx.new file
    		book.default_sheet = book.sheets.first

    		#validate file

    		2.upto(book.last_row) do |line|
    			params = {}
    			HEADERS.each_with_index do |k,i|
    				params[k] = book.cell(line,i+1)
          end
        end
        msg.result = true
        msg.content = "成功"
        msg
    	end

    	def self.validate_import file
        msg = Message.new
        book = Roo::Excelx.new file
        book.default_sheet = book.sheets.first

        #validate file

        2.upto(book.last_row) do |line|
          params = {}
          HEADERS.each_with_index do |k,i|
            params[k] = book.cell(line,i+1)
          end

          mssg = Message.new
          mssg = validate_row(params)

        end
        msg.result = true
        msg.content = "成功"
        msg
    	end

    	def self.validate_row row

    	end
    end
  end
end
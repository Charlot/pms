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

      def self.import_produce file

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
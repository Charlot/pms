module FileHandler
  module Excel
    class Kanban<Base
    	HEADERS=[
    		'Nr','Quantity','Safety Stock','Copies',
    		'Remark','Wire Nr','Product Nr','Type',
    		'Bundle','Source Warehouse','Source Storage','Destination Warehouse',
    		'Destination Storage','Process List'
    	]

    	def self.import file
    		book = Roo::Excel.new file
    		book.default_sheet = book.sheets.first

    		#validate file

    		2.upto(book.last_row) do |line|
    			params = {}
    			HEADERS.each_with_index do |k,i|
    				params[k] = book.cell(line,i+1)
    			end

          if params['Nr']
            kanban = Kanban.find_by_nr(params['Nr'])
          else

          end
    		end
    	end

    	def self.validate_import file

    	end

    	def self.validate_row row

    	end
    end
  end
end
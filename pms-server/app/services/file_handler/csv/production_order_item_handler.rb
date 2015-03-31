require 'csv'
module FileHandler
  module Csv
    class ProductionOrderItemHandler<Base
      EXPORT_CSV_HEADERS=%w(No OrderItemNr Kanban Machine OrderNr PartNr)

      def export_optimized(items, user_agent, tmp_path=nil)
        msg=Message.new
        begin
          tmp_file = ProductionOrderItemHandler.full_tmp_path('优化数据.csv') unless tmp_file
          CSV.open(tmp_file, 'wb', write_headers: true,
                   headers: EXPORT_CSV_HEADERS,
                   col_sep: SEPARATOR, encoding: ProductionOrderItemHandler.get_encoding(user_agent)) do |csv|
            items.each_with_index do |item, i|
              csv<<[i+1,
                    item.nr,
                    item.kanban_nr,
                    item.machine_nr,
                    item.production_order_nr,
                    item.kanban.wire_nr
              ]
            end
          end
          msg.result =true
          msg.content =tmp_file
        rescue => e
          msg.content =e.message
        end
        msg
      end
    end
  end
end


# msg.content = "请下载错误文件<a href='/files/#{Base64.urlsafe_encode64(tmp_file)}'>#{::File.basename(tmp_file)}</a>"
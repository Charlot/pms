require 'csv'
module FileHandler
  module Csv
    class ProductionOrderItemHandler<Base
      # EXPORT_CSV_HEADERS=%w(No OrderItemNr Kanban Machine OrderNr PartNr Material)
      STATE_EXPORT_CSV_HEADERS=%w(No ItemNr OrderNr State OptimiseIndex Machine  KanbanNr ProductNr KanbanWireNr KanbanQuantity KanbanBundle ProducedQty WireNr Diameter WireLength Terminal1Nr Tool1Nr Terminal1StripLength Terminal2Nr Tool2Nr Terminal2StripLength Seal1Nr Seal2Nr UpdateTime)
      EXPORT_CSV_HEADERS=STATE_EXPORT_CSV_HEADERS

      def export_optimized(items, user_agent, tmp_path=nil)
        msg=Message.new
        # begin
          tmp_file = ProductionOrderItemHandler.full_tmp_path('优化数据.csv') unless tmp_file
          CSV.open(tmp_file, 'wb', write_headers: true,
                   headers: EXPORT_CSV_HEADERS,
                   col_sep: ';', encoding: ProductionOrderItemHandler.get_encoding(user_agent)) do |csv|
            # items.each_with_index do |item, i|
            #   material = item.kanban.material.collect { |p| "#{p.nr}|#{PartType.display(p.type)}" }.join(";")
            #   csv<<[i+1,
            #         item.nr,
            #         item.kanban_nr,
            #         item.machine_nr,
            #         item.production_order_nr,
            #         item.kanban.wire_nr,
            #         material
            #   ]
            # end
            items=ProductionOrderItemPresenter.init_preview_presenters(items)
            items.each_with_index do |item, i|
              row=[]
              STATE_EXPORT_CSV_HEADERS.each do |head|
                row<< (head=='State' ? ProductionOrderItemState.display(item[:State]) : item[head.to_sym])
              end
              csv<<row
            end
            csv<<[] if items.count==0
          end
          msg.result =true
          msg.content =tmp_file
        # rescue => e
        #   msg.content =e.message
        # end
        msg
      end

      def export_by_state(params, user_agent, tmp_path=nil)
        msg=Message.new
        # begin
          tmp_file = ProductionOrderItemHandler.full_tmp_path('订单数据.csv') unless tmp_file
          CSV.open(tmp_file, 'wb', write_headers: true,
                   headers: STATE_EXPORT_CSV_HEADERS,
                   col_sep: ';', encoding: ProductionOrderItemHandler.get_encoding(user_agent)) do |csv|

            q= ProductionOrderItem.joins(:machine).order(machine_id: :asc, production_order_id: :asc, optimise_index: :asc)
            q= q.where(machines: {nr: params[:machine_nr]}) unless params[:machine_nr].blank?
            q= q.where(state: params[:state]) unless params[:state].blank?
            q=q.where(production_order_id: params[:production_order_id]) unless params[:production_order_id].blank?

            begin
              q=q.where(updated_at: [Time.parse(params[:start_time]).utc..Time.parse(params[:end_time]).utc]) unless params[:start_time].blank? || params[:end_time].blank?
            end

            items=ProductionOrderItemPresenter.init_preview_presenters(q.all)
            items.each do |item|
              if item
                row=[]
                STATE_EXPORT_CSV_HEADERS.each do |head|
                  row<< (head=='State' ? ProductionOrderItemState.display(item[:State]) : item[head.to_sym])
                end
                csv<<row
              end
            end
            csv<<[] if items.count==0
          end
          msg.result =true
          msg.content =tmp_file
        # rescue => e
        #   msg.content =e.message
        # end
        msg
      end

      def self.get_encoding(user_agent)
        os=System::Base.os_by_user_agent(user_agent)
        case os
          when 'windows'
            return 'GB18030:UTF-8'
          when 'linux', 'macintosh'
            return 'UTF-8:UTF-8'
          else
            return 'UTF-8:UTF-8'
        end
      end
    end
  end
end


# msg.content = "请下载错误文件<a href='/files/#{Base64.urlsafe_encode64(tmp_file)}'>#{::File.basename(tmp_file)}</a>"
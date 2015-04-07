module V1
  module Service
    class NcrServiceAPI<ServiceBase
      guard_all!
      namespace :ncr do
        # 配置机器API
        namespace :setting do
          post :ip do
            msg=ServiceMessage.new
            if machine=Machine.find_by_nr(params[:machine_nr])
              if params[:ip]=~Resolv::IPv4::Regex
                msg.Result = machine.update(ip: params[:ip])
                msg.Content='IP 设置成功!'
              else
                msg.Content = "Machine IP #{params[:ip]} is not valid"
              end
            else
              msg.Content="No Machine Nr: #{params[:machine_nr]}"
            end
            msg
          end
        end

        namespace :order do
          # 加载最新Order
          get :first_wait_produce do
            if machine=Machine.find_by_nr(params[:machine_nr])
              return ProductionOrderItemPresenter.new(ProductionOrderItem.first_wait_produce(machine)).to_check_material_order
            end
          end

          # preview order item list
          get :preview do
            if machine=Machine.find_by_nr(params[:machine_nr])
              return ProductionOrderItemPresenter.init_preview_presenters(ProductionOrderItem.for_produce(machine).all)
            end
          end

          get :produce_content do
            if item=ProductionOrderItem.find_by_id(params[:order_item_id])
              return ProductionOrderItemPresenter.new(item).to_produce_order
            end
          end

          put :update_state do
            if item=ProductionOrderItem.find_by_nr(params[:order_item_nr])
              return item.update(state: params[:state])
            end
          end

          post :produce_piece do
            ProductionOrderItem.transaction do
              if item=ProductionOrderItem.find_by_nr(params[:order_item_nr])
                # TODO generate bundle storage
                item.update(produced_qty: params[:produced_qty])
                return ProductionOrderItemPresenter.new(item).to_bundle_produce_order
              end
            end
          end

        end

        namespace :printer do
          get :kanban_by_order_item do
            if item=ProductionOrderItem.find_by_nr(params[:order_item_nr])
              printer=Printer::Client.new({code: params[:code], id: item.kanban_id})
              printer.gen_data
            end
          end


          get :bundle_label do
            if item=ProductionOrderItem.find_by_nr(params[:order_item_nr])
              printer=Printer::Client.new({code: params[:code],
                                           id: item.kanban_id,
                                           machine_nr: params[:machine_nr],
                                           bundle_no: params[:bundle_no]})
              printer.gen_data
            end
          end
        end

      end
    end
  end
end
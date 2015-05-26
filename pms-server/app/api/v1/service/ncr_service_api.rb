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
                msg.Content='IP Settled!'
              else
                msg.Content = "Machine IP #{params[:ip]} is not valid"
              end
            else
              msg.Content="No Machine Nr:#{params[:machine_nr]}"
            end
            msg
          end

          post :tool do
            if item=ProductionOrderItem.find_by_nr(params[:order_item_nr])
              puts "-------------------#{params.to_json}".red
              item.without_versioning do
                item.update_attributes(tool1: params[:tool1_nr], tool2: params[:tool2_nr])
              end
            end
            msg=ServiceMessage.new
            msg.Result=true
            msg.Content="Success"
            msg
          end
        end

        namespace :order do
          # 加载最新Order
          get :first_wait_produce do
            if machine=Machine.find_by_nr(params[:machine_nr])
              order = ProductionOrderItem.first_wait_produce(machine)
              if order
                r= ProductionOrderItemPresenter.new(order).to_check_material_order
              else
                r= {}
              end
              NcrLogWorker.perform_async({machine_nr: params[:machine_nr],
                                          log_type: NcrApiLogType::MACHINE_MATERIAL_CHECK,
                                          return_detail: r.to_json,
                                          params_detail: params.to_json})
              return r
            end
          end

          # preview order item list
          get :preview do
            if machine=Machine.find_by_nr(params[:machine_nr])
              return ProductionOrderItemPresenter.init_preview_presenters(ProductionOrderItem.for_produce(machine))
            end
          end

          # get order item passed
          get :passed do
            if machine=Machine.find_by_nr(params[:machine_nr])
              return ProductionOrderItemPresenter.init_preview_presenters(ProductionOrderItem.for_passed(machine).limit(30))
            end
          end

          get :produce_content do
            if item=ProductionOrderItem.find_by_id(params[:order_item_id])
              mirror= params.has_key?(:mirror)
              return ProductionOrderItemPresenter.new(item).to_produce_order(mirror)
            end
          end

          put :update_state do
            if item=ProductionOrderItem.find_by_nr(params[:order_item_nr])
              # 当任务结束时，不可以使用API改变状态
              r=false
              if item.state==ProductionOrderItemState::TERMINATED
                r= false
              else
                r= item.update(state: params[:state], user_nr: params[:user_nr], user_group_nr: params[:user_group_nr])
              end

              NcrLogWorker.perform_async({order_item_nr: params[:order_item_nr],
                                          log_type: NcrApiLogType::ORDER_UPDATE_STATE,
                                          order_item_state: params[:state],
                                          return_detail: r, params_detail: params.to_json})
              return r
            end
          end

          post :produce_piece do
            ProductionOrderItem.transaction do
              if item=ProductionOrderItem.find_by_nr(params[:order_item_nr])
                # TODO generate bundle storage
                item.update(produced_qty: params[:produced_qty])
                r= ProductionOrderItemPresenter.new(item).to_bundle_produce_order

                NcrLogWorker.perform_async({order_item_nr: params[:order_item_nr],
                                            log_type: NcrApiLogType::MACHINE_OUT_PUT_QTY,
                                            return_detail: r.to_json,
                                            order_item_qty: params[:produced_qty],
                                            params_detail: params.to_json})

                return r
              end
            end
          end


          get :item_search do
            items=ProductionOrderItem
            if params[:wire_nr]
              ids= Kanban.search_for(params[:wire_nr]).pluck(:id)
              items=items.joins(:kanban).where(kanbans: {id: ids}) if ids.count>0
            end
            items=items.limit(100)
            if items.count>0
              return ProductionOrderItemPresenter.init_preview_presenters(items)
            end
            return nil
          end
        end

        namespace :printer do
          get :kanban_by_order_item do
            if item=ProductionOrderItem.find_by_nr(params[:order_item_nr])
              printer=Printer::Client.new({code: params[:code], id: Kanban.find_by_id(item.kanban_id).nr, machine_nr: params[:machine_nr]})
              printer.gen_data
            end
          end


          get :bundle_label do
            if item=ProductionOrderItem.find_by_nr(params[:order_item_nr])
              unless params[:in_store].blank?
                item.create_label(params[:bundle_no])
              end
              printer=Printer::Client.new({code: params[:code],
                                           id: item.kanban_id,
                                           machine_nr: params[:machine_nr],
                                           bundle_no: params[:bundle_no],
                                           order_item_nr: params[:order_item_nr]})
              printer.gen_data
            end
          end
        end

      end
    end
  end
end

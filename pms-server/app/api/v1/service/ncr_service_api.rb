module V1
  module Service
    class NcrServiceAPI<ServiceBase
      guard_all!
      namespace :ncr do
        # 配置机器API
        namespace :setting do
          post :ip do
            msg=Message.new
            if machine=Machine.find_by_nr(params[:machine_nr])
              if params[:ip]=~Resolv::IPv4::Regex
                msg.result = machine.update(ip: params[:ip])
              else
                msg.content = "Machine IP #{params[:ip]} is not valid"
              end
            else
              msg.content="No Machine Nr: #{params[:machine_nr]}"
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

          get :produce_order_content do
            if item=ProductionOrderItem.find_by_id(params[:order_id])
              return ProductionOrderItemPresenter.new(item).to_produce_order
            end
          end
        end
      end
    end
  end
end
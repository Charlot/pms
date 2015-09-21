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
              # item.without_versioning do
              item.update_attributes(tool1: params[:tool1_nr], tool2: params[:tool2_nr])
              # end

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
                # puts order.to_json.red
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
              return ProductionOrderItemPresenter.init_preview_presenters(ProductionOrderItem.for_produce(machine).limit(Setting::MACHINE_PREVIEW_QTY))
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
              return ProductionOrderItemPresenter.new(item).to_produce_order(params[:machine_type],mirror)
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
              items=items.joins(:kanban).where(kanbans: {id: ids}).order(nr: :desc) if ids.count>0
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

        namespace :spc do
          get :crimp_configuration_by_order do
            resilt = []
            index = 0
            msg=ServiceMessage.new

            production_order_item = ProductionOrderItem.find_by_nr(params[:production_order_item_id])
            if production_order_item.nil?
              msg.Content = "This order:#{params[:production_order_item_id]} is not valid!"
              return msg
            end

            process_entity = production_order_item.kanban.process_entities.first
            if process_entity.nil?
              msg.Content = "Can not find process entity!"
              return msg
            end

            wire = Part.find(process_entity.value_wire_nr)
            if wire.nil?
              msg.Content = "Can not find wire!"
              return msg
            end
            wire_type = wire.component_type
            cross_section = wire.cross_section
            part_custom_nr = Part.find(production_order_item.kanban.product_id).nr
            custom_id = CustomDetail.where("part_nr_to >= ? AND part_nr_from <= ?", part_custom_nr, part_custom_nr).first.custom_nr

            unless process_entity.value_t1.nil?
              part1_id = Part.find(process_entity.value_t1).nr
              item1 = CrimpConfiguration.where(custom_id: custom_id, part_id: part1_id, wire_type: wire_type, cross_section: cross_section).first
              unless item1.nil?
                args1 = {}
                args1[:Key] = part1_id
                args1[:Value] = {Min_pullOff_value: item1.min_pulloff_value, Crimp_height: item1.crimp_height, Crimp_height_iso: item1.crimp_height_iso, Crimp_width: item1.crimp_width, Crimp_width_iso: item1.crimp_width_iso, I_crimp_height: item1.i_crimp_height, I_crimp_height_iso: item1.i_crimp_height_iso, I_crimp_width: item1.i_crimp_width, I_crimp_width_iso: item1.i_crimp_width_iso}
                resilt[index] = args1
                index += 1
              end
            end

            unless process_entity.value_t2.nil?
              part2_id = Part.find(process_entity.value_t2).nr
              item2 = CrimpConfiguration.where(custom_id: custom_id, part_id: part2_id, wire_type: wire_type, cross_section: cross_section).first
              unless item2.nil?
                args2 = {}
                args2[:Key] = part2_id
                args2[:Value] = {Min_pullOff_value: item2.min_pulloff_value, Crimp_height: item2.crimp_height, Crimp_height_iso: item2.crimp_height_iso, Crimp_width: item2.crimp_width, Crimp_width_iso: item2.crimp_width_iso, I_crimp_height: item2.i_crimp_height, I_crimp_height_iso: item2.i_crimp_height_iso, I_crimp_width: item2.i_crimp_width, I_crimp_width_iso: item2.i_crimp_width_iso}
                resilt[index] = args2
              end
            end
            {
                Result: true,
                Object: resilt
            }
          end

          post :store_measured_data do
            puts params
            msg=ServiceMessage.new
            record = MeasuredValueRecord.new(machine_id: params[:machine_id], production_order_id: params[:production_order_id], part_id: params[:part_id], crimp_height_1: params[:crimp_height_1], crimp_height_2: params[:crimp_height_2], crimp_height_3: params[:crimp_height_3], crimp_height_4: params[:crimp_height_4], crimp_height_5: params[:crimp_height_5], crimp_width: params[:crimp_width], i_crimp_heigth: params[:i_crimp_heigth], i_crimp_width: params[:i_crimp_width], pulloff_value: params[:pulloff_value], note: params[:note])
            if record.save
              msg.Result = true
              msg.Content = "Success"
            else
              msg.Result = false
              msg.Content = "Failed"
            end

            msg
          end
        end

      end
    end
  end
end

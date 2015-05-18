class ProductionOrderItemLabelService
  def self.enter_stock(id)
    ProductionOrderItemLabel.transaction do
      if (label=ProductionOrderItemLabel.find_by_id(id)) && (label.state==ProductionOrderItemLabel::INIT)
        r=false
        if (kb=label.production_order_item.kanban) && kb.full_wire_nr
          r=Whouse::Storage.new.enter_stock({partNr: kb.full_wire_nr,
                                             qty: label.qty,
                                             fifo: label.created_at.localtime,
                                             toWh: label.whouse_nr,
                                             toPosition: label.position_nr,
                                             packageId: label.nr
                                            })
        end
        if r
          label.update(state: ProductionOrderItemLabel::IN_STORE)
        else
          label.update(state: ProductionOrderItemLabel::ENTER_STOCK_FAIL)
        end
      end
    end
  end


  def self.move_stock(id, from_whouse='SR01', from_position='SR01')
    ProductionOrderItemLabel.transaction do
      if (label=ProductionOrderItemLabel.find_by_id(id)) && (item =label.production_order_item)
        if (kb=item.kanban) && (pe=kb.process_entities.first)
          base_params={
              toWh: label.whouse_nr,
              toPosition: label.whouse_nr,
              fromWh: from_whouse,
              fromPosition: from_position
          }
          moves=[]
          if part=Part.find_by_id(pe.value_default_wire_nr)
            part.part_boms.joins(:bom_item).select('part_boms.*,parts.nr,parts.type as part_type').each do |pb|
              qty = pb.part_type==PartType::MATERIAL_WIRE ? pb.quantity/1000 : pb.quantity
              moves<<base_params.merge({
                                           qty: qty,
                                           partNr: pb.nr
                                       })

            end
            puts "#{moves}".red
            Whouse::Storage.new.move_stocks(moves) if moves.size>0
          end
        end
      end
    end
  end
end
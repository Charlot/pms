class ItemLabelMoveStockWorker
  include Sidekiq::Worker
  sidekiq_options(queue: :store)

  def perform(id, from_whouse, from_position)
    ProductionOrderItemLabel.transaction do
      if (label=ProductionOrderItemLabel.find_by_id(id)) && (item =label.production_order_item)
        if (kb=item.kanban) && (pe=kb.process_entities.first)
          base_params={
              toWh: label.whouse_nr,
              toPosition: label.whouse_nr,
              fromWh: from_whouse,
              fromPosition: from_position
          }
          # move wire
          # unit of wire is mm, but move store should use m
          if (wire=Part.find_by_id(pe.value_wire_nr))
            Whouse::Storage.new.move_stock(base_params.merge({
                                                                 qty: pe.value_wire_qty_factor.to_f/1000*label.qty,
                                                                 partNr: wire.nr
                                                             }))
          end

          #move terminator
          if(t1=Part.find_by_id(pe.value_t1))
            Whouse::Storage.new.move_stock(base_params.merge({
                                                                 qty:  pe.value_t1_qty_factor.to_f*label.qty,
                                                                 partNr: t1.nr
                                                             }))
          end

          if(t2=Part.find_by_id(pe.value_t2))
            Whouse::Storage.new.move_stock(base_params.merge({
                                                                 qty:  pe.value_t2_qty_factor.to_f*label.qty,
                                                                 partNr: t2.nr
                                                             }))
          end

          #move seal
          if(s1=Part.find_by_id(pe.value_s1))
            Whouse::Storage.new.move_stock(base_params.merge({
                                                                 qty:  pe.value_s1_qty_factor.to_f*label.qty,
                                                                 partNr: s1.nr
                                                             }))
          end

          if(s2=Part.find_by_id(pe.value_s2))
            Whouse::Storage.new.move_stock(base_params.merge({
                                                                 qty:  pe.value_s2_qty_factor.to_f*label.qty,
                                                                 partNr: s2.nr
                                                             }))
          end
        end
      end
    end
  end
end
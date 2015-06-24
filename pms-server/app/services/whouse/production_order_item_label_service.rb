class ProductionOrderItemLabelService
  def self.enter_stock(id)
    ProductionOrderItemLabel.transaction do
      if (label=ProductionOrderItemLabel.find_by_id(id)) && (label.state==ProductionOrderItemLabel::INIT)
        r=false
        if (kb=label.production_order_item.kanban) && kb.kanban_part_nr
          r=Whouse::Storage.new.enter_stock({partNr: kb.kanban_part_nr,
                                             qty: label.qty,
                                             fifo: label.created_at.localtime,
                                             toWh: label.whouse_nr,
                                             toPosition: label.position_nr,
                                             packageId: label.nr,
                                             uniq: true
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
        if kb=item.kanban
          base_params={
              toWh: label.whouse_nr,
              toPosition: label.whouse_nr,
              fromWh: from_whouse,
              fromPosition: from_position
          }
          moves=[]
          kb.materials.each do |material|
            moves<<base_params.merge({
                                         qty: material.quantity,
                                         partNr: material.nr
                                     })
          end
          Whouse::Storage.new.move_stocks(moves) if moves.size>0
        end
      end
    end
  end

  def self.move_blue_stock(id, from_whouse='SR01', from_position='SR01')
    if (item=ProductionOrderItemBlue.find_by_id(id)) && (kb =item.kanban)
      toWh=toPosition=Warehouse.get_whouse_by_position_prefix(kb.des_storage)
      base_params={toWh: toWh,
                   toPosition: toPosition,
                   fromWh: from_whouse,
                   fromPosition: from_position}
      moves=[]
      kb.materials.each do |material|
        moves<<base_params.merge({
                                     qty: material.quantity,
                                     partNr: material.nr
                                 })
      end
      Whouse::Storage.new.move_stocks(moves) if moves.size>0
    end
  end
end
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
                                             locked: true
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

  def self.enter_blue_stock(id)
    ProductionOrderItemBlueLabel.transaction do
      if (label=ProductionOrderItemBlueLabel.find_by_id(id)) && (label.state==ProductionOrderItemBlueLabel::INIT)
        r=false
        puts '----------------------------------'
        if (kb=label.production_order_item_blue.kanban) && kb.kanban_part_nr
          puts '----------------------------------ddd'

          r=Whouse::Storage.new.enter_stock({partNr: kb.kanban_part_nr,
                                             qty: label.qty,
                                             fifo: label.created_at.localtime,
                                             toWh: label.whouse_nr,
                                             toPosition: label.position_nr,
                                             packageId: label.nr,
                                             locked: true
                                            })
        end
        if r
          label.update(state: ProductionOrderItemBlueLabel::IN_STORE)
        else
          label.update(state: ProductionOrderItemBlueLabel::ENTER_STOCK_FAIL)
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
              fromWh: from_whouse
          }
          moves=[]
          kb.materials.each do |material|
            moves<<base_params.merge({
                                         qty: BigDecimal.new(material.quantity.to_s)*label.qty,
                                         partNr: material.nr
                                     })
          end
          Whouse::Storage.new.move_stocks(moves) if moves.size>0
        end
      end
    end
  end

  def self.move_blue_stock(id, from_whouse='SR01', from_position='SR01')
    return false
    ProductionOrderItemBlueLabel.transaction do
      if (label=ProductionOrderItemBlueLabel.find_by_id(id)) && (item =label.production_order_item_blue)
        if kb=item.kanban
          base_params={
              toWh: label.whouse_nr,
              toPosition: label.whouse_nr,
              fromWh: from_whouse
          }
          moves=[]

          kb.kanban_part.materials_with_deep.each do |material|
            moves<<base_params.merge({
                                         qty: BigDecimal.new(material.quantity.to_s)*label.qty,
                                         partNr: material.nr,
                                         from_whouse: material.deep==1 ? 'SR01' : 'SRPL'
                                     })
          end
          Whouse::Storage.new.move_stocks(moves) if moves.size>0
        end
      end
    end
  end
end
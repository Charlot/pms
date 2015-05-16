class ItemLabelInStockWorker
  include Sidekiq::Worker
  sidekiq_options(queue: :store)

  def perform(id)
    ProductionOrderItemLabel.transaction do
      if label=ProductionOrderItemLabel.find_by_id(id)
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
          label.update(state: IN_STORE)
        else
          label.update(state: ENTER_STOCK_FAIL)
        end
      end
    end
  end
end
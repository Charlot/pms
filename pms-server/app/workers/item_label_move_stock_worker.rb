class ItemLabelMoveStockWorker
  include Sidekiq::Worker
  sidekiq_options(queue: :store)

  def perform(id)
    ProductionOrderItemLabelService.move_stock(id)
    #ProductionOrderItemService.move_stock(id)
  end
end
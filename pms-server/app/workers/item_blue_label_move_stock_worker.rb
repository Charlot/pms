class ItemBlueLabelMoveStockWorker
  include Sidekiq::Worker
  sidekiq_options(queue: :store)

  def perform(id)
    ProductionOrderItemLabelService.move_blue_stock(id)
  end
end
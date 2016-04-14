class ItemBlueMoveStockWorker
  include Sidekiq::Worker
  sidekiq_options(queue: :store)

  def perform(id)
    ProductionOrderItemService.move_blue_stock(id)
  end
end
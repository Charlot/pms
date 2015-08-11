class ItemBlueInStockWorker
  include Sidekiq::Worker
  sidekiq_options(queue: :store)

  def perform(id)
    ProductionOrderItemLabelService.enter_blue_stock(id)
  end
end
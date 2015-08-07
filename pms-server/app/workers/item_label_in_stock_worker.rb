class ItemLabelInStockWorker
  include Sidekiq::Worker
  sidekiq_options(queue: :store)

  def perform(id)
    ProductionOrderItemLabelService.enter_stock(id)
  end
end
class ItemBlueMoveStockWorker
  include Sidekiq::Worker
  sidekiq_options(queue: :store)

  def perform(id)

  end
end
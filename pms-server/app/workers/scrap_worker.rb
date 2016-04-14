class ScrapWorker
  include Sidekiq::Worker
  sidekiq_options(queue: :scraps)

  def perform(params)
    ProductionOrderScrapService.move_stock(params)
  end
end
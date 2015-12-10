class ProductionOrderScrapService
  def self.move_stock(params)
    Whouse::StorageClient.new.move_stocks(params)
  end
end

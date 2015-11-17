class ProductionOrderScrapService
  def self.move_stock(params)
    puts "NStorage Move #{params.to_json}".red
    Whouse::StorageClient.new.move_stocks(params)
  end
end

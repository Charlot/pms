json.array!(@production_orders) do |production_order|
  json.extract! production_order, :id, :nr, :state
  json.url production_order_url(production_order, format: :json)
end

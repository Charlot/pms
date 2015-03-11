json.array!(@production_orders) do |production_order|
  json.extract! production_order, :id, :state, :code, :kanban_id
  json.url production_order_url(production_order, format: :json)
end

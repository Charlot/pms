json.array!(@production_order_items) do |production_order_item|
  json.extract! production_order_item, :id, :nr, :state, :code, :kanban_id, :production_order
  json.url production_order_item_url(production_order_item, format: :json)
end

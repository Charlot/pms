json.array!(@production_order_handler_items) do |production_order_handler_item|
  json.extract! production_order_handler_item, :id, :nr, :desc, :remark, :kanban_code, :kanban_nr, :result, :handler_user, :item_terminated_at, :production_order_handler_id
  json.url production_order_handler_item_url(production_order_handler_item, format: :json)
end

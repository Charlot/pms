json.array!(@production_order_handler_list_items) do |production_order_handler_list_item|
  json.extract! production_order_handler_list_item, :id, :nr, :desc, :kanban_code, :kanban_nr, :result, :handler_user, :item_terminated_at, :production_order_handler_list_id
  json.url production_order_handler_list_item_url(production_order_handler_list_item, format: :json)
end

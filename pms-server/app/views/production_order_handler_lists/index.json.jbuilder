json.array!(@production_order_handler_lists) do |production_order_handler_list|
  json.extract! production_order_handler_list, :id, :nr, :desc
  json.url production_order_handler_list_url(production_order_handler_list, format: :json)
end

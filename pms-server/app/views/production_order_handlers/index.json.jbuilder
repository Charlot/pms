json.array!(@production_order_handlers) do |production_order_handler|
  json.extract! production_order_handler, :id, :nr, :desc, :remark
  json.url production_order_handler_url(production_order_handler, format: :json)
end

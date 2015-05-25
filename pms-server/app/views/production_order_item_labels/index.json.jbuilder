json.array!(@production_order_item_labels) do |production_order_item_label|
  json.extract! production_order_item_label, :id, :production_order_item_id, :bundle_no, :qty, :nr, :state
  json.url production_order_item_label_url(production_order_item_label, format: :json)
end

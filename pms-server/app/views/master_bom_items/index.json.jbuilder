json.array!(@master_bom_items) do |master_bom_item|
  json.extract! master_bom_item, :id, :qty, :bom_item_id, :product_id, :department_id
  json.url master_bom_item_url(master_bom_item, format: :json)
end

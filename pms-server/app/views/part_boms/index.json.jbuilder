json.array!(@part_boms) do |part_bom|
  json.extract! part_bom, :id, :part_id, :bom_item_id, :quantity
  json.url part_bom_url(part_bom, format: :json)
end

json.array!(@process_parts) do |process_part|
  json.extract! process_part, :id, :quantity, :part_id, :process_entity_id, :unit
  json.url process_part_url(process_part, format: :json)
end

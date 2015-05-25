json.array!(@resource_group_parts) do |resource_group_part|
  json.extract! resource_group_part, :id, :part_id, :resource_group_id
  json.url resource_group_part_url(resource_group_part, format: :json)
end

json.array!(@part_positions) do |part_position|
  json.extract! part_position, :id
  json.url part_position_url(part_position, format: :json)
end

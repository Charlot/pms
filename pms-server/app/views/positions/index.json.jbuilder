json.array!(@positions) do |position|
  json.extract! position, :id, :detail, :warehouse_id
  json.url position_url(position, format: :json)
end

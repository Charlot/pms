json.array!(@parts) do |part|
  json.extract! part, :id, :nr, :custom_nr, :part_type, :measure_unit_id
  json.url part_url(part, format: :json)
end

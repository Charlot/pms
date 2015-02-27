json.array!(@parts) do |part|
  json.extract! part, :id, :nr, :custom_nr, :type, :strip_length, :resource_group_id, :measure_unit_id
  json.url part_url(part, format: :json)
end

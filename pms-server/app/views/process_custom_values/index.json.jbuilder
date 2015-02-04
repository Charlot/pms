json.array!(@process_custom_values) do |process_custom_value|
  json.extract! process_custom_value, :id, :customized_type, :customized_id, :custom_field_id, :value
  json.url process_custom_value_url(process_custom_value, format: :json)
end

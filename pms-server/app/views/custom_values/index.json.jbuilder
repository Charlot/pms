json.array!(@custom_values) do |custom_value|
  json.extract! custom_value, :id, :customized_type, :customized_id, :custom_field_id, :value
  json.url custom_value_url(custom_value, format: :json)
end

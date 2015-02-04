json.array!(@custom_fields) do |custom_field|
  json.extract! custom_field, :id, :type, :name, :field_format, :possible_values, :regexp, :min_length, :max_length, :is_required, :is_for_all, :is_filter, :position, :searchable, :default_value, :editable, :visible, :multiple, :format_store, :is_query_value, :validate_query, :value_query, :description
  json.url custom_field_url(custom_field, format: :json)
end

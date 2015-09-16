json.array!(@crimp_configurations) do |crimp_configuration|
  json.extract! crimp_configuration, :id, :custom_id, :wire_group_name, :part_id, :wire_type, :cross_section
  json.url crimp_configuration_url(crimp_configuration, format: :json)
end

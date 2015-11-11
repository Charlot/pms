json.array!(@wire_groups) do |wire_group|
  json.extract! wire_group, :id, :group_name, :wire_type, :cross_section
  json.url wire_group_url(wire_group, format: :json)
end

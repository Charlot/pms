json.array!(@resource_groups) do |resource_group|
  json.extract! resource_group, :id, :nr, :type, :name, :description
  json.url resource_group_url(resource_group, format: :json)
end

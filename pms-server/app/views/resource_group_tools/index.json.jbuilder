json.array!(@resource_group_tools) do |resource_group_tool|
  json.extract! resource_group_tool, :id, :nr, :type, :name, :description
  json.url resource_group_tool_url(resource_group_tool, format: :json)
end

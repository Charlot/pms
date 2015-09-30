json.array!(@part_tools) do |part_tool|
  json.extract! part_tool, :id, :part_id, :tool_id
  json.url part_tool_url(part_tool, format: :json)
end

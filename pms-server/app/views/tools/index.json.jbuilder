json.array!(@tools) do |tool|
  json.extract! tool, :id, :nr, :resource_group_id, :part_id, :mnt, :used_days, :rql, :tol, :rql_date
  json.url tool_url(tool, format: :json)
end

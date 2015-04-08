json.array!(@machines) do |machine|
  json.extract! machine, :id, :nr, :name, :description, :resource_group_id
  json.url machine_url(machine, format: :json)
end

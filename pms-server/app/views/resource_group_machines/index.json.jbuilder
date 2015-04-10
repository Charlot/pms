json.array!(@resource_group_machines) do |resource_group_machine|
  json.extract! resource_group_machine, :id, :nr, :type, :name, :description
  json.url resource_group_machine_url(resource_group_machine, format: :json)
end

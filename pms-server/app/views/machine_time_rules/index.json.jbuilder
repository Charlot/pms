json.array!(@machine_time_rules) do |machine_time_rule|
  json.extract! machine_time_rule, :id, :oee_code_id, :machine_type_id, :length, :time
  json.url machine_time_rule_url(machine_time_rule, format: :json)
end

json.array!(@process_entities) do |process_entity|
  json.extract! process_entity, :id, :nr, :name, :description, :stand_time, :process_template_id, :workstation_type_id, :cost_center_id
  json.url process_entity_url(process_entity, format: :json)
end

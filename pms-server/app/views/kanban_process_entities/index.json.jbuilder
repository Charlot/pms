json.array!(@kanban_process_entities) do |kanban_process_entity|
  json.extract! kanban_process_entity, :id, :Kanban_id, :ProcessEntity_id
  json.url kanban_process_entity_url(kanban_process_entity, format: :json)
end

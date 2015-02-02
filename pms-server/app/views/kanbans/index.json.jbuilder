json.array!(@kanbans) do |kanban|
  json.extract! kanban, :id
  json.url kanban_url(kanban, format: :json)
end

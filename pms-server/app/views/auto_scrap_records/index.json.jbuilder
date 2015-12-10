json.array!(@auto_scrap_records) do |auto_scrap_record|
  json.extract! auto_scrap_record, :id, :order_nr, :kanban_nr, :machine_nr, :part_nr, :qty, :user_id
  json.url auto_scrap_record_url(auto_scrap_record, format: :json)
end

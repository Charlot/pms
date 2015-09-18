json.array!(@custom_details) do |custom_detail|
  json.extract! custom_detail, :id, :part_nr_from, :part_nr_to, :custom_nr
  json.url custom_detail_url(custom_detail, format: :json)
end

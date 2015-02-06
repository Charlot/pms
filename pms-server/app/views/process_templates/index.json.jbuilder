json.array!(@process_templates) do |process_template|
  json.extract! process_template, :id, :code, :type, :name, :template, :description
  json.url process_template_url(process_template, format: :json)
end

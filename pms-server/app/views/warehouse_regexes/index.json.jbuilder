json.array!(@warehouse_regexes) do |warehouse_regex|
  json.extract! warehouse_regex, :id, :regex, :warehouse_nr, :desc
  json.url warehouse_regex_url(warehouse_regex, format: :json)
end

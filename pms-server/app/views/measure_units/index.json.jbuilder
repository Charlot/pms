json.array!(@measure_units) do |measure_unit|
  json.extract! measure_unit, :id, :code, :describe, :cn, :en
  json.url measure_unit_url(measure_unit, format: :json)
end

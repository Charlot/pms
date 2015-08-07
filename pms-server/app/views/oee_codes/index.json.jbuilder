json.array!(@oee_codes) do |oee_code|
  json.extract! oee_code, :id
  json.url oee_code_url(oee_code, format: :json)
end

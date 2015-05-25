json.array!(@settings) do |setting|
  json.extract! setting, :id, :name, :value, :stype
  json.url setting_url(setting, format: :json)
end

json.array!(@crimp_configuration_items) do |crimp_configuration_item|
  json.extract! crimp_configuration_item, :id, :side, :min_pulloff, :crimp_height, :crimp_height_iso, :crimp_width, :crimp_width_iso, :i_crimp_height, :i_crimp_height_iso, :i_crimp_width, :i_crimp_width_iso
  json.url crimp_configuration_item_url(crimp_configuration_item, format: :json)
end

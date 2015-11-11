json.array!(@measured_value_records) do |measured_value_record|
  json.extract! measured_value_record, :id, :production_order_id, :crimp_height_1, :crimp_height_2, :crimp_height_3, :crimp_height_4, :crimp_height_5, :crimp_width, :i_crimp_heigth, :i_crimp_width, :pulloff_value, :note
  json.url measured_value_record_url(measured_value_record, format: :json)
end

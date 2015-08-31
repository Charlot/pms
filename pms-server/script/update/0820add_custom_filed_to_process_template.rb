if pt=ProcessTemplate.find_by_code('5202')
	puts '------------before'.yellow
    puts pt.to_json

	count=pt.custom_fields.count
	cf=CustomField.build_by_format('float',"float_#{count}",pt.custom_field_type,count)

	pt.custom_fields<<cf

	pt.template+="，长度为{#{cf.id}}"

	pt.save

	puts '------------after'.blue
    puts pt.to_json
end

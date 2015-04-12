parts = Part.where("nr like '%_TW%'").collect{|p|p.id}
puts parts

product = Part.find_by_nr("93NMA001A")

kanbans = ProcessEntity.joins(:process_template,:custom_values).where({custom_values:{value:parts},product_id:product.id,process_templates:{type:ProcessType::AUTO}}).collect{|pe|pe.kanbans.first.nr}
puts kanbans.count
puts kanbans.join(";")
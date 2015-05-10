oee_codes = %w(CC CW CS WW SW SS)
oee_des = [
    "两端压端子",
    "一端压端子，一端剥线",
    "一端压端子，一端防水圈",
    "两端剥线",
    "一端剥线，一端防水圈",
    "两端防水圈"
]

#
puts "======================".yellow
puts "8.新建Oee Code 工时代码".yellow
puts "======================".yellow
OeeCode.destroy_all
oee_codes.each_with_index do |oee,i|
  if (o= OeeCode.find_by_nr(oee)).present?
    o.update({description:oee_des[i]})
  else
    o = OeeCode.create({nr:oee,description:oee_des[i]})
  end
  o.save
end

MachineType.destroy_all
["CC36","CC64"].each do |type|
  MachineType.create({nr:type})
end
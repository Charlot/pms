prouct = Part.find_by_nr("93NMA001A");
Kanban.where("ktype = #{KanbanType::WHITE} and product_id = #{prouct.id} and des_storage like '%XM%' ").each do |k|
  puts "#{k.quantity},#{k.des_storage}"
  if k.quantity > 0
    k.update(quantity:50)
  end
end
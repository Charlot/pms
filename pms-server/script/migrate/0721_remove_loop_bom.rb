#Part.all.each_with_index do |part,i|
 #puts "#{i+1}. #{part.nr}"

 #begin
     #puts part.materials.to_json
 #rescue
	 #puts '-----------ERROR-----------'.red
	 #puts part.leaf(part.id)
 #end
#end

PartBom.where('part_id=bom_item_id').destroy_all


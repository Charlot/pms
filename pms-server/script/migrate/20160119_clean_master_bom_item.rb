MasterBomItem.transaction do
  MasterBomItem.group(:product_id, :bom_item_id, :department_id).having('count(*)>1').all.each do |item|
    p item
    MasterBomItem.where(product_id: item.product_id, bom_item_id: item.bom_item_id, department_id: item.department).offset(1).all.each do |i|
      p i
      i.destroy
    end
  end
end
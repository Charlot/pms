ProcessEntity.transaction do
  data=[]
  ProcessEntity.all.each do |pe|
    if pe.product.blank?
      # data<<pe.nr
      pe.destroy
    end
  end
end
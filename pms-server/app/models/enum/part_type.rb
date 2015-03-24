class PartType<BaseType
  MATERIAL_WIRE=0 #原材料线
  MATERIAL_TERMINAL=1 #原材料端子
  MATERIAL_SEAL=2 #原材料防水圈
  MATERIAL_OTHER=3
  PRODUCT_SEMIFINISHED=4 #半成品
  PRODUCT=5 #成品

  def self.list_value
    self.constants.collect { |c|
      self.const_get(c)
    }
  end

  def self.is_material?(type)
    constants.select{|c|
      c if c.to_s =~/MATERIAL_/
    }.collect{|c| const_get(c)}.include?(type.to_i)
  end
end
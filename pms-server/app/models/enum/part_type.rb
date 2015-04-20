class PartType<BaseType
  MATERIAL_WIRE=0 #原材料线
  MATERIAL_TERMINAL=1 #原材料端子
  MATERIAL_SEAL=2 #原材料防水圈
  MATERIAL_OTHER=3
  PRODUCT_SEMIFINISHED=4 #半成品
  PRODUCT=5 #成品

  def self.display type
    case type
    when MATERIAL_WIRE
      'Material Wire'
    when MATERIAL_TERMINAL
      'Material Contact'
    when MATERIAL_SEAL
      'Material Seal'
    when MATERIAL_OTHER
      'Material Other'
    when PRODUCT_SEMIFINISHED
      'Product Semi'
    when PRODUCT
      'Product'
    end
  end

  def self.list_value
    self.constants.collect { |c|
      self.const_get(c)
    }
  end

  def self.is_material?(type)
    [MATERIAL_WIRE,MATERIAL_TERMINAL,MATERIAL_SEAL,MATERIAL_OTHER].include?(type.to_i)
  end
end
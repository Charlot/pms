class PartType<BaseType
  MATERIAL_WIRE=0 #原材料线
  MATERIAL_TERMINAL=1 #原材料端子
  MATERIAL_SEAL=2 #原材料防水圈
  MATERIAL_OTHER=3
  PRODUCT_SEMIFINISHED=4 #半成品
  PRODUCT=5 #成品

  @@MaterialTypes= [MATERIAL_WIRE, MATERIAL_TERMINAL, MATERIAL_SEAL, MATERIAL_OTHER]

  def self.display type
    case type
      when MATERIAL_WIRE
        '原材料线'
      when MATERIAL_TERMINAL
        '端子'
      when MATERIAL_SEAL
        '防水圈'
      when MATERIAL_OTHER
        '其它原材料'
      when PRODUCT_SEMIFINISHED
        '半成品'
      when PRODUCT
        '成品'
    end
  end


  def self.get_value_by_display display
    case display
      when '原材料线'
        MATERIAL_WIRE
      when '端子'
        MATERIAL_TERMINAL
      when '防水圈'
        MATERIAL_SEAL
      when '其它原材料'
        MATERIAL_OTHER
      when '半成品'
        PRODUCT_SEMIFINISHED
      when '成品'
        PRODUCT
    end
  end

  #
  # def self.display type
  #   case type
  #   when MATERIAL_WIRE
  #     'Material Wire'
  #   when MATERIAL_TERMINAL
  #     'Material Contact'
  #   when MATERIAL_SEAL
  #     'Material Seal'
  #   when MATERIAL_OTHER
  #     'Material Other'
  #   when PRODUCT_SEMIFINISHED
  #     'Product Semi'
  #   when PRODUCT
  #     'Product'
  #   end
  # end


  def self.list_value
    self.constants.collect { |c|
      self.const_get(c)
    }
  end

  def self.is_material?(type)
    @@MaterialTypes.include?(type.to_i)
  end

  def self.MaterialTypes
    @@MaterialTypes
  end

end
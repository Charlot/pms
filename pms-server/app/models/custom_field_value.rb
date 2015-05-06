class CustomFieldValue<BaseClass
  attr_accessor :id,:custom_field, :customized, :value, :value_was


  def custom_field_id
    custom_field.id
  end

  def true?
    self.value == '1'
  end

  def editable?
    custom_field.editable?
  end

  def visible?
    custom_field.visible?
  end

  def required?
    custom_field.is_required?
  end

  def to_s
    value.to_s
  end

  def validate_value
    custom_field.validate_custom_value(self).each do |message|
      customized.errors.add(:base, custom_field.name + ' ' + message)
    end
  end
end

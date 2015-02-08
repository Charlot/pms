class CustomFieldPart<CustomField
  # before_save :validate_query

  def validate_field(args)
    validate_validate_query(args)
  end

  def validate_validate_query(args)
    args=self.class.parse_args(args)
    query=field_to_query(args)
    # lt is not safe, should improve later
    unless value=eval(query)
      raise('未通过验证查询')
    else
      return value
    end
  end

  def get_field_value(args)
    args=self.class.parse_args(args)
    validate_validate_query(args)
    return eval(field_to_query(args))
  end

  private
  def field_to_query(args)
    self.validate_query.gsub('#').each_with_index { |v, i| "'#{args[i]}'" }
  end
end
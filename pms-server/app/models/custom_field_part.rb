class CustomFieldPart<CustomField
  # before_save :validate_query

  def validate_field(args)
    validate_validate_query(args)
  end

  def validate_validate_query(args)
    query=self.validate_query.gsub('#').each_with_index { |v, i| "'#{args[i]}'" }
    # lt is not safe, should improve later
    unless value=eval(query)
      raise('未通过验证查询')
    else
      return value
    end
  end

  def get_value_query_value(args)

  end


end
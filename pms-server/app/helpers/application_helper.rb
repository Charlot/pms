module ApplicationHelper
  def to_enum_value(v)
    v.nil? ? v : v.to_i
  end
end

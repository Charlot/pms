class BaseType<BaseClass
  class<<self
    define_method(:has_value?) { |s| self.constants.map { |c| self.const_get(c.to_s) }.include?(s) }
  end

  def get_type(type)
    const_get(type.upcase)
  end

  def self.display(v)
    v=v.to_i
    constant_by_value(v)
  end

  def self.to_select
    select_options = []
    constants.each do |c|
      v = const_get(c.to_s)
      select_options << SelectOption.new(display: self.display(v), value: v)
    end
    select_options
  end
end
class BaseType<BaseClass

  # def self.method_missing(method_name, *args, &block)
  #   mn=method_name.to_s.sub(/\?/, '')
  #   if /\w+\?/.match(method_name.to_s) && (const=self.const_get(mn.upcase))
  #     # class << self
  #       define_method(method_name) { |s| const== s}
  #     # end
  #   else
  #     super
  #   end
  # end

  class<<self
    define_method(:has_value?) { |s| self.constants.map { |c| self.const_get(c.to_s) }.include?(s) }
  end


  def self.get_type(type)
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
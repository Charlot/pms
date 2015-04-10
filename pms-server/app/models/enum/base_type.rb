class BaseType<BaseClass

  def self.method_missing(method_name, *args, &block)
    mn=method_name.to_s.sub(/\?/, '')
    if /\w+\?/.match(method_name.to_s)
      begin
        self.const_get(mn.upcase)==args[0].to_i
      rescue
        super
      end
    else
      super
    end
  end

  class<<self
    define_method(:has_value?) { |s| self.constants.map { |c| self.const_get(c.to_s) }.include?(s) }
  end


  def self.get_type(type)
    const_get(type.upcase)
  end

  def self.display(v)
    constant_by_value(v)
  end

  def self.include_value?(v)
    constants.collect{|c|const_get(c.to_s)}.include?(v.to_i)
  end

  def self.key(v)
    constant_by_value(v).downcase
  end

  def self.to_select
    select_options = []
    constants.each do |c|
      v = const_get(c.to_s)
      select_options << SelectOption.new(display: self.display(v), value: v, key: self.key(v))
    end
    select_options
  end
end
class BaseClass

  def initialize(args={})

    if self.respond_to?(:default)
      self.default.each do |k, v|
        instance_variable_set "@#{k}", v
      end
    end

    args.each do |k, v|

      instance_variable_set "@#{k}", v
    end
  end

  def self.constant_by_value(v)
    constants.find { |name| const_get(name)==v }
  end
end
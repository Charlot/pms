module Kernel
  def class_defined?(class_name)
    begin
      return self.const_get(class_name).is_a?(Class)
    rescue NameError
      return false
    end
  end
end
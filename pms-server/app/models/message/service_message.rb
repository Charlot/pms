class ServiceMessage<BaseClass
  attr_accessor :Result, :Object, :Content, :Contents

  def default
    {Result: false}
  end
end
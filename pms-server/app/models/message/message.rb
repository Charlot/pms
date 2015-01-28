class Message<BaseClass
  attr_accessor :result, :object, :content

  def default
    {result: false}
  end
end
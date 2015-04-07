class Message<BaseClass
  attr_accessor :result, :object, :content, :contents

  def default
    {result: false}
  end
end
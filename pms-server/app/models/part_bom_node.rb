class PartBomNode<BaseClass
  attr_accessor :is_root, :node, :children,:deep

  def default
    {is_root: false,deep:0}
  end
end
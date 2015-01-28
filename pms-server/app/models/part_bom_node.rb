class PartBomNode<BaseClass
  attr_accessor :is_root, :node, :children

  def default
    {is_root: false}
  end
end
class PartBomNode<BaseClass
  attr_accessor :is_root,:id, :node, :part_nr, :part_id,:bom_item_id,:type, :quantity, :children, :deep

  def default
    {is_root: false, deep: 0}
  end
end
class PartBom < ActiveRecord::Base
  validates :part_id, uniqueness: {scope: :bom_item_id, message: 'part bom item should be uniq'}

  belongs_to :part
  belongs_to :bom_item, class_name: 'Part'

  def self.detail_by_part_id(id)
    if part=Part.find_by_id(id)
      return detail_by_part(part)
    end
  end

  def self.detail_by_part(part)
    deep=0
    pbn=PartBomNode.new(node: part, is_root: true,deep:deep)
    if part_boms=by_part_id(part.id)
      pbn.children=call_detail_by_part(part_boms,deep)
    end if by_part_id(part.id).count>0
    return pbn
  end


  def self.children_by_part(part)
    children=[]
    if part_boms=by_part_id(part.id)
      call_children_by_part(part_boms, children)
    end
    return children
  end

  def self.leaf_by_part(part, type=nil)
    leaf=[]
    if part_boms=by_part_id(part.id,type)
      call_leaf_by_part(part_boms, leaf, type)
    end
    return leaf
  end


  def self.call_detail_by_part(part_boms,deep=0)
    deep+=1
    nodes=[]
    part_boms.each do |part_bom|
      node=PartBomNode.new(deep:deep)
      node.node=part_bom
      nodes<<node
      node.children=call_detail_by_part(by_part_id(part_bom.bom_item_id),deep)
    end
    return nodes.size==0 ? nil : nodes
  end

  def self.call_children_by_part(part_boms, children)
    part_boms.each do |part_bom|
      children<<part_bom
      call_children_by_part(by_part_id(part_bom.bom_item_id), children)
    end
  end

  def self.call_leaf_by_part(part_boms, leaf, type=nil)
    part_boms.each do |part_bom|
      leaf<<part_bom if part_bom.is_leaf?
      call_leaf_by_part(by_part_id(part_bom.bom_item_id, type), leaf, type)
    end
  end

  def self.by_part_id(part_id, type=nil)
    q=joins(:bom_item).where(part_id: part_id)
    if type
      q=q.where(parts: {type: type})
    end
    q.select('*')
  end

  def is_leaf?
    PartBom.where(part_id: self.bom_item_id).count==0
  end
end

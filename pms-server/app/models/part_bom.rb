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
    pbn=PartBomNode.new(node: part, is_root: true)
    if part_boms=by_part_id(part.id)
      pbn.children=call_detail_by_part(part_boms)
    end
    return pbn
  end


  def self.call_detail_by_part(part_boms)
    nodes=[]
    part_boms.each do |part_bom|
      node=PartBomNode.new
      node.node=part_bom
      puts part_bom.to_json
      nodes<<node
      node.children=call_detail_by_part(by_part_id(part_bom.bom_item_id))
    end
    return nodes.size==0 ? nil : nodes
  end

  def self.by_part_id(part_id)
    joins(:bom_item).where(part_id: part_id).select('parts.*,part_boms.*')
  end

end

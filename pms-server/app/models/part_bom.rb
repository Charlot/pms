class PartBom < ActiveRecord::Base
  validates :part_id, uniqueness: {scope: :bom_item_id, message: 'part bom item should be uniq'}

  belongs_to :part
  belongs_to :bom_item, class_name: 'Part'
end

class ResourceGroupTool<ResourceGroup
  default_scope { where(type: ResourceGroupType::TOOL) }
  # has_many :resource_group_parts, foreign_key: :resource_group_id
  has_one :resource_group_part, foreign_key: :resource_group_id, dependent: :destroy
  # has_many :parts, through: :resource_group_parts
  has_one :part, through: :resource_group_part
  has_many :tools, dependent: :destroy

  validate :resource_group_part_presence

  private

  def resource_group_part_presence
    errors.add(:resource_group_part, 'part is blank') if self.resource_group_part.blank?
  end
end
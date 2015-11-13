class ResourceGroupTool<ResourceGroup
  default_scope { where(type: ResourceGroupType::TOOL) }
  has_many :resource_group_parts, foreign_key: :resource_group_id
  has_many :parts, through: :resource_group_parts
  has_many :tools, dependent: :destroy

end
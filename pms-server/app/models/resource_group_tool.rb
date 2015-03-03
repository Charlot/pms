class ResourceGroupTool<ResourceGroup
  default_scope { where(type: ResourceGroupType::TOOL) }
end
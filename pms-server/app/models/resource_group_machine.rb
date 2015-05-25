class ResourceGroupMachine<ResourceGroup
  has_many :machines

  default_scope { where(type: ResourceGroupType::MACHINE) }

end
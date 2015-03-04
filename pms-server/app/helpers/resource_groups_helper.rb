module ResourceGroupsHelper
  def resource_group_type_options
    ResourceGroupType.to_select.map { |t| [t.display, t.value] }
  end

  def machine_resource_group_options
    ResourceGroupMachine.all.map { |r| [r.nr, r.id] }
  end

  def tool_resource_group_options
    ResourceGroupTool.all.map { |r| [r.nr, r.id] }
  end
end

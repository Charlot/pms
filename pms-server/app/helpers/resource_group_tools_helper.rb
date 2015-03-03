module ResourceGroupToolsHelper
  def tool_resource_group_options
    ResourceGroupTool.all.map { |r| [r.nr, r.id] }
  end
end

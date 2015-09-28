module ResourceGroupToolsHelper
  def resource_group_tool_options
    ResourceGroupTool.order(nr: :asc).all.collect { |g| [g.nr, g.id] }
  end
end

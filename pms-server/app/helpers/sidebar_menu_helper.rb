module SidebarMenuHelper
  def sidebar(model)
    if SidebarMenu.respond_to? model
      SidebarMenu.send(model)
    else
      []
    end
  end
end
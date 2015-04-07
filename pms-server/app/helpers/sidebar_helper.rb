module SidebarHelper
  def sidebar_info(model)
    if model && (Enum::SidebarMenu.respond_to? model)
      Enum::SidebarMenu.send(model)
    else
      []
    end
  end

  def page_title(model,action)
    if model && action &&(Enum::PageInfo.respond_to? "#{model}_#{action}")
      Enum::PageInfo.send("#{model}_#{action}")
    else
      nil
    end
  end
end
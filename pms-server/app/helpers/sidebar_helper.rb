module SidebarHelper
  def sidebar_info(model)
    if Enum::SidebarMenu.respond_to? model
      Enum::SidebarMenu.send(model)
    else
      []
    end
  end

  def page_title(model,action)
    puts "#{model}_#{action}"
    if Enum::PageInfo.respond_to? "#{model}_#{action}"
      Enum::PageInfo.send("#{model}_#{action}")
    else
      nil
    end
  end
end
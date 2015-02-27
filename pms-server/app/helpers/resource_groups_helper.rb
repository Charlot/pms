module ResourceGroupsHelper
  def resource_group_type_options
    ResourceGroupType.to_select.map { |t| [t.display, t.value] }
  end

  def method_missing(method_name, *args, &block)
    if /\w+_resource_group_options/.match(method_name.to_s)
      ResourceGroup.where(type: ResourceGroupType.const_get(method_name.to_s.sub(/_resource_group_options/, '').upcase)).map { |r| [r.nr, r.id] }
    else
      super
    end
  end
end

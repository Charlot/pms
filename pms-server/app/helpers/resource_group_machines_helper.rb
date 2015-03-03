module ResourceGroupMachinesHelper
  def machine_resource_group_options
    ResourceGroupMachine.all.map { |r| [r.nr, r.id] }
  end
end

module MachineTypesHelper
  def machine_type_options
    MachineType.all.map{ |mt| [mt.nr, mt.id]}
  end
end

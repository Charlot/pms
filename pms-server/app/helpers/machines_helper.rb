module MachinesHelper
  def machine_options
    Machine.all.collect { |m| [m.nr, m.id] }
  end
end

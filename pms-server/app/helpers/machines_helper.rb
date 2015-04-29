module MachinesHelper
  def machine_options
    Machine.order(nr: :asc).all.collect { |m| [m.nr, m.id] }
  end
end

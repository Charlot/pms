module DepartmentsHelper
  def department_options
    Department.all.collect { |d| [d.name, d.id] }
  end
end

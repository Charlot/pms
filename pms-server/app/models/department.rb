class Department < ActiveRecord::Base
  validates :code, :uniqueness => {:message => "#{DepartmentDesc::CODE} 不能重复！"}

end

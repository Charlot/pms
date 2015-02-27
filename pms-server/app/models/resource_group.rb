class ResourceGroup < ActiveRecord::Base
  self.inheritance_column = :_type_disabled

  validates :nr, presence: true, uniqueness: {message: 'resource group nr should be uniq'}

end
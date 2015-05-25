class ResourceGroup < ActiveRecord::Base
  self.inheritance_column = :_type_disabled

  validates :nr, presence: true, uniqueness: {message: 'resource group nr should be uniq'}

  before_create :init_container_attr

  def init_container_attr
    self.type=ResourceGroupType.get_type(self.class.name.sub(/ResourceGroup/, ''))
  end
end
class CustomField < ActiveRecord::Base
  self.inheritance_column = :_type_disabled

  has_many :custom_values, :dependent => :delete_all

  scope :sorted, lambda { order(:position) }
end

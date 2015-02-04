class CustomField < ActiveRecord::Base
  has_many :custom_values, :dependent => :delete_all
end

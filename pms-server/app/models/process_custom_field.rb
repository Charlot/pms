class ProcessCustomField < ActiveRecord::Base
  has_many :process_custom_values, :dependent => :delete_all
end

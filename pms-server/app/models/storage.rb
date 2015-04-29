class Storage < ActiveRecord::Base
  belongs_to :warehouse
  belongs_to :part
end
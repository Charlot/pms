class ProductionOrder < ActiveRecord::Base
  include AutoKey
  has_many :production_order_items
end

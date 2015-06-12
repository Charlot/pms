class ProductionOrderHandler < ActiveRecord::Base
  include AutoKey
  has_many :production_order_handler_items
end

class ProductionOrder < ActiveRecord::Base
  include AutoKey
  has_many :production_order_items
  #has_many :production_order_item_blues
  self.inheritance_column = :_type_disabled
  default_scope { where(type: ProductionOrderType::WHITE) }
end

class ProductionOrderBlue<ProductionOrder
  default_scope { where(type: ProductionOrderType::BLUE) }
  has_many :production_order_item_blues,foreign_key: :production_order_id
end

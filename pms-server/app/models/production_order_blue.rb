class ProductionOrderBlue<ProductionOrder
  default_scope { where(type: ProductionOrderType::BLUE) }

end

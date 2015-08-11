class ProductionOrderHandlerItem < ActiveRecord::Base
  include AutoKey

  belongs_to :production_order_handler

  SUCCESS=100
  FAIL=200
end

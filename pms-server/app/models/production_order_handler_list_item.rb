class ProductionOrderHandlerListItem < ActiveRecord::Base
  include AutoKey

  belongs_to :production_order_handler_list
end

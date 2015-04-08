class MasterBomItem < ActiveRecord::Base
  belongs_to :department
  belongs_to :product, class_name: 'Part'
  belongs_to :bom_item, class_name: 'Part'
end

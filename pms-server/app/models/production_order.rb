class ProductionOrder < ActiveRecord::Base
  belongs_to :orderable, polymorphic: true
end

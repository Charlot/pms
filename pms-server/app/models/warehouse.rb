class Warehouse < ActiveRecord::Base
  validates :nr, presence: true, uniqueness: {message: 'nr should be uniq'}
end

class Part < ActiveRecord::Base
  belongs_to :measure_unit
  has_many :part_boms
  has_many :kanbans
  validates :nr, presence: true, uniqueness: {message: 'part nr should be uniq'}

end

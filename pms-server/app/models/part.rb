class Part < ActiveRecord::Base
  belongs_to :measure_unit
  has_many :part_boms
  validates :nr, presence: true, uniqueness: {message: 'part nr should be uniq'}

end

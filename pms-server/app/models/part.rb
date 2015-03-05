class Part < ActiveRecord::Base
  belongs_to :resource_group
  belongs_to :measure_unit
  has_many :part_boms
  has_many :kanbans
  validates :nr, presence: true, uniqueness: {message: 'part nr should be uniq'}

  after_save :update_cv_strip_length

  private
  def update_cv_strip_length
    if self.strip_length_changed?
    end
  end
end

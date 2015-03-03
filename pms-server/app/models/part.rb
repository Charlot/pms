class Part < ActiveRecord::Base
  belongs_to :resource_group
  belongs_to :measure_unit
  has_many :part_boms
  has_many :kanbans
  has_one :resource_group_part
  # delegate :resource_group_tool, to: :resource_group_part
  has_one :resource_group_tool, through: :resource_group_part

  validates :nr, presence: true, uniqueness: {message: 'part nr should be uniq'}

  after_save :update_cv_strip_length

  private
  def update_cv_strip_length
    if self.strip_length_changed?
    end
  end
end

class Tool < ActiveRecord::Base
  validates :nr, presence: true, uniqueness: {message: 'tool nr should be uniq'}

  belongs_to :resource_group_tool, foreign_key: :resource_group_id
  belongs_to :part
  attr_accessor :part_nr

  validate :part_group_presence

  private
  def part_group_presence
    errors.add(:part, 'not input') if self.part.blank?
    errors.add(:resource_group_tool, 'group is not set the part') if self.resource_group_tool.blank?
  end
end

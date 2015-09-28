class Tool < ActiveRecord::Base
  validates :nr, presence: true, uniqueness: {message: 'tool nr should be uniq'}

  belongs_to :resource_group_tool, foreign_key: :resource_group_id
  has_many :part_tools, dependent: :delete_all
  has_many :parts, through: :part_tools

  attr_accessor :part_nrs
  scoped_search on: :nr

  def part_nrs
    @part_nrs||= parts.pluck(:nr).join(',')
  end

  def part_nrs=(value)
    puts 'value.............'
  end
end

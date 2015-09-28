class Tool < ActiveRecord::Base
  validates :nr, presence: true, uniqueness: {message: 'tool nr should be uniq'}
  self.inheritance_column = nil

  # default_scope { where(locked: false) }
  belongs_to :resource_group_tool, foreign_key: :resource_group_id
  has_many :part_tools, dependent: :delete_all
  has_many :parts, through: :part_tools


  attr_accessor :part_nrs
  scoped_search on: :nr
  scoped_search in: :parts, on: :nr

  before_validation :validate_part_nrs
  after_save :handle_part_nrs


  def part_nrs
    @part_nrs||= parts.pluck(:nr).join(',')
  end

  private
  def validate_part_nrs
    if @part_nrs
      @part_nrs.split(',').each do |part_nr|
        unless Part.find_by_nr(part_nr)
          self.errors.add(:part_nr, "可用零件:#{part_nr} 不存在")
        end
      end
    end
  end

  def handle_part_nrs

    old_parts=self.part_tools.pluck(:id)
    @part_nrs.split(',').each do |part_nr|
      part=Part.find_by_nr(part_nr)
      if pt=self.part_tools.where(part_id: part.id).first
        old_parts.delete(pt.id)
      else
        self.part_tools<<PartTool.new(part: part)
      end
    end if @part_nrs
    self.part_tools.where(id: old_parts).delete_all
  end

end

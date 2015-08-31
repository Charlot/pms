class KanbanType < BaseType
  WHITE=0
  BLUE=1

  def self.display type
    case type
    when WHITE
      '白卡'
    when BLUE
      '兰卡'
    else
      '未知'
    end
  end
end
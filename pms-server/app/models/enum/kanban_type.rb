class KanbanType
  WHITE=0
  BLUE=1

  def self.display type
    case type
      when WHITE
        '全自动'
      when BLUE
        '半自动'
      else
        '未知'
    end
  end

  def self.list
    
  end
end
class WireFromType<BaseType
  SEMI_AUTO=0
  AUTO=1

  def self.display(type)
    case type
      when SEMI_AUTO
        '半自动'
      when AUTO
        '全自动'
      else
        ''
    end
  end
end
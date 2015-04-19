class WireFromType<BaseType
  SEMI_AUTO=0
  AUTO=1

  def self.display(type)
    case type
      when SEMI_AUTO
        '来自半自动'
      when AUTO
        '来自全自动'
      else
        ''
    end
  end
end
class ProductionOrderState
  INIT = 0
  # STARTED=1
  # FINISHED=2

  def self.display(state)
    case state
      when INIT
        'Init'
      # when STARTED
      #   '进行中'
      # when FINISHED
      #   '已结束'
      else
        'Init'
    end
  end
end
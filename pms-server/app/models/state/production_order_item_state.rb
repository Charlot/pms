class ProductionOrderItemState
  INIT = 100
  OPTIMISE_FAIL=110
  OPTIMISE_SUCCEED=120
  OPTIMISE_CANCELED=130
  DISTRIBUTE_FAIL=140
  DISTRIBUTE_SUCCEED=150
  STARTED=200
  ABORTED=300
  FINISHED=400

  def self.display(state)
    case state
      when INIT
        '已扫描'
      when OPTIMISE_FAIL
        '优化失败'
      when OPTIMISE_SUCCEED
        '优化成功'
      when OPTIMISE_CANCELED
        '优化取消'
      when DISTRIBUTE_FAIL
        '分发失败'
      when DISTRIBUTE_SUCCEED
        '已分发'
      when STARTED
        '进行中'
      when ABORTED
        '已终止'
      when FINISHED
        '已结束'
      else
        'Init'
    end
  end

  def self.optimise_states
    [INIT, OPTIMISE_FAIL]
  end

  def self.distribute_states
    [OPTIMISE_SUCCEED,DISTRIBUTE_FAIL]
  end
end
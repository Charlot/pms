class ProductionOrderItemState<BaseType
  INIT = 100
  OPTIMISE_FAIL=110
  OPTIMISE_SUCCEED=120
  OPTIMISE_CANCELED=130
  DISTRIBUTE_FAIL=140
  DISTRIBUTE_SUCCEED=150
  STARTED=200
  RESTARTED=300
  TERMINATED=400
  ABORTED=500
  MANUAL_ABORTED=501
  INTERRUPTED=600
  PAUSED=700
  SCANNED=800


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
      when RESTARTED
        '已重启'
      when TERMINATED
        '已结束'
      when ABORTED
        '已终止'
      when MANUAL_ABORTED
        '手动终止'
      when INTERRUPTED
        '已中断'
      when PAUSED
        '已暂停'
      when SCANNED
        '已销卡'
      else
        'Init'
    end
  end

  def self.optimise_states
    [INIT, OPTIMISE_FAIL]
  end

  def self.distribute_states
    [OPTIMISE_SUCCEED, DISTRIBUTE_FAIL]
  end

  def self.wait_produce_states
    DISTRIBUTE_SUCCEED
  end

  def self.wait_scan_states
    [TERMINATED]
  end
end
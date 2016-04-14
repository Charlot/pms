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
  SYSTEM_ABORTED=502
  INTERRUPTED=600
  PAUSED=700
  SCANNED=800

  def self.display(state)
    case state
      when INIT
        I18n.t 'production_order_item_state.INIT'
      # '已扫描'
      when OPTIMISE_FAIL
        # '优化失败'
        I18n.t 'production_order_item_state.OPTIMISE_FAIL'

      when OPTIMISE_SUCCEED
        # '优化成功'
        I18n.t 'production_order_item_state.OPTIMISE_SUCCEED'

      when OPTIMISE_CANCELED
        # '优化取消'
        I18n.t 'production_order_item_state.OPTIMISE_CANCELED'

      when DISTRIBUTE_FAIL
        # '分发失败'
        I18n.t 'production_order_item_state.DISTRIBUTE_FAIL'

      when DISTRIBUTE_SUCCEED
        I18n.t 'production_order_item_state.DISTRIBUTE_SUCCEED'
      when STARTED
        # '进行中'
        I18n.t 'production_order_item_state.STARTED'

      when RESTARTED
        # '已重启'
        I18n.t 'production_order_item_state.RESTARTED'

      when TERMINATED
        # '已结束'
        I18n.t 'production_order_item_state.TERMINATED'

      when ABORTED
        # '已终止'
        I18n.t 'production_order_item_state.ABORTED'

      when MANUAL_ABORTED
        # '手动终止'
        I18n.t 'production_order_item_state.MANUAL_ABORTED'

      when SYSTEM_ABORTED
        # '系统终止'
        I18n.t 'production_order_item_state.SYSTEM_ABORTED'

      when INTERRUPTED
        # '已中断'
        I18n.t 'production_order_item_state.INTERRUPTED'

      when PAUSED
        # '已暂停'
        I18n.t 'production_order_item_state.PAUSED'

      when SCANNED
        # '已销卡'
        I18n.t 'production_order_item_state.SCANNED'

      else
        # 'Init'
        I18n.t 'production_order_item_state.INIT'

    end
  end

  def self.optimise_states
    [INIT, OPTIMISE_FAIL]
  end

  def self.sort_states
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

  def self.passed_states
    [STARTED, RESTARTED, TERMINATED, ABORTED, MANUAL_ABORTED, SYSTEM_ABORTED, INTERRUPTED, PAUSED]
  end

  def self.to_blue_select
    select_options = []
    [INIT, DISTRIBUTE_SUCCEED, TERMINATED].each do |v|
      select_options << SelectOption.new(display: self.display(v), value: v, key: self.key(v))
    end
    select_options
  end
end
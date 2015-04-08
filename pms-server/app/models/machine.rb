class Machine < ActiveRecord::Base
  belongs_to :resource_group_machine, foreign_key: :resource_group_id
  has_one :machine_scope
  has_many :machine_combinations
  OPTIMISE_TIME_MATCH_MAP={wire_nr: :wire_time, t1: :terminal_time, t2: :terminal_time,
                           s1: :seal_time, s2: :seal_time, w2: :wire_time, t3: :terminal_time, t4: :terminal_time, s3: :seal_time, s4: :seal_time}


  def optimise_time_by_kanban(kanban)
    optimise_time=0
    template=kanban.process_entities.first.process_template
    OPTIMISE_TIME_MATCH_MAP.keys.each do |k|
      if template.send("field_#{k}")
        optimise_time+=self.send(OPTIMISE_TIME_MATCH_MAP[k])
      end
    end
    return optimise_time
  end
end

class CrimpConfiguration < ActiveRecord::Base
  before_create :init_wire_type

  def init_wire_type
    self[:wire_type] = WireGroup.where(group_name: self[:wire_group_name], cross_section: self[:cross_section]).first.wire_type
  end
end

class WireGroup < ActiveRecord::Base
  validates_presence_of :wire_type, :message => "电线型号不能为空!"
  validates_presence_of :cross_section, :message => "截面不能为空!"
  validates_presence_of :group_name, :message => "线组名称不能为空!"
  before_validation :check_data

  def check_data
    item = WireGroup.where(wire_type: self.wire_type, cross_section: self.cross_section.to_f).first
    if !item.nil? && item.id != self.id
      self.errors.add(:group_name,"wire_type:#{self.wire_type}, cross_section:#{self.cross_section},该信息已存在线组名：#{item.group_name}")
    end
  end
end

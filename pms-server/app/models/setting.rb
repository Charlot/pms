class Setting < ActiveRecord::Base
  validates :code, :value, presence: true
  AUTO_MOVE_KANBAN_CODE='auto_move_kanban'
  AUTO_CONVERT_MATERIAL_LENGTH='auto_convert_material_length'
  ROUTING_MATERIAL_LENGTH_UNIT='routing_material_length_unit'
  MATERIAL_PART_MARK='material_part_mark'
  NONE_MATERIAL_PART_MARK='none_material_part_mark'

  def self.method_missing(method_name, *args, &block)
    puts '-------------------'
    if setting=Setting.where(code: method_name).first
      return setting.value
    else
      super
    end
  end

  def self.auto_move_kanban?
    self.auto_move_kanban=='1'
  end


  def self.auto_convert_material_length?
    self.auto_convert_material_length=='1'
  end
end

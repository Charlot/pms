class Setting < ActiveRecord::Base
  validates :code, :value, presence: true
  AUTO_MOVE_KANBAN_CODE='auto_move_kanban'
  AUTO_CONVERT_MATERIAL_LENGTH='auto_convert_material_length'
  ROUTING_MATERIAL_LENGTH_UNIT='routing_material_length_unit'
  MATERIAL_PART_MARK='material_part_mark'
  NONE_MATERIAL_PART_MARK='none_material_part_mark'
  KANBAN_QTY_CHANGE_ORDER='kanban_qty_change_order'
  PRESETER_CHANGE_ITEM_QTY='presenter_change_item_qty'
  # MACHINE_PREVIEW_QTY='machine_preview_qty'

  def self.method_missing(method_name, *args, &block)
    puts method_name

    if method_name.match(/\?$/)
      puts '----------------------'
      if setting=Setting.where(code: method_name.to_s.sub(/\?$/,'')).first
        return setting.value=='1'
      else
        super
      end
    elsif setting=Setting.where(code: method_name).first
      return setting.value
    else
      super
    end
  end


  def self.check_kanban_version?
    false
  end
end

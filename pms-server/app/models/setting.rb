class Setting < ActiveRecord::Base
  validates :code, :value, presence: true
  AUTO_MOVE_KANBAN_CODE='auto_move_kanban'

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
end

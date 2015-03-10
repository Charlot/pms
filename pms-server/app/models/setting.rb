class Setting < ActiveRecord::Base
  validates :stype,presence: true, uniqueness: {message:"不能添加相同类型的设置"}
  validates :name,:value, presence: true

  def self.printer_url
    ""
  end
end

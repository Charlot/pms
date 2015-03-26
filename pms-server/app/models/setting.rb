class Setting < ActiveRecord::Base
  validates :stype,presence: true, uniqueness: {message:"不能添加相同类型的设置"}
  validates :name,:value, presence: true

  def self.printer_url
    if s = self.find_by_stype(SettingType::PRINTER_URL)
      s.value
    else
      nil
    end
  end

  def self.wms_url
    if s = self.find_by_stype(SettingType::WMS_URL)
      s.value
    else
      nil
    end
  end
end

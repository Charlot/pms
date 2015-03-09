class SettingType<BaseType
  PRINTER_URL = 0

  def self.display(type)
    case type
    when PRINTER_URL
      '打印服务器地址'
    else
      '未知'
    end
  end

end
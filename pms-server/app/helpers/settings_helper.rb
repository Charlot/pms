module SettingsHelper
  def setting_type_options
    SettingType.to_select.map{|t| [t.display, t.value]}
  end
end

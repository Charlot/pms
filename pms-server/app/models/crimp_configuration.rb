class CrimpConfiguration < ActiveRecord::Base
  # before_create :init_wire_type
  belongs_to :tool


  def self.to_xlsx crimp_configurations
    p = Axlsx::Package.new

    wb = p.workbook
    wb.add_worksheet(:name => "sheet1") do |sheet|
      sheet.add_row ["ID", "客户号", "模具号", "端子号", "线组名称", "截面", "最小拉力值", "压接高度", "压接高度公差", "压接宽度", "压接宽度公差", "绝缘压接高度",
                     "绝缘压接高度公差", "绝缘压接宽度", "绝缘压接宽度公差"]
      crimp_configurations.each_with_index { |crimp_configuration, index|
        sheet.add_row [
                          crimp_configuration.id,
                          crimp_configuration.custom_id,
                          crimp_configuration.tool.blank? ? '' : crimp_configuration.tool.nr,
                          crimp_configuration.part_id,
                          crimp_configuration.wire_group_name,
                          crimp_configuration.cross_section,

                          crimp_configuration.min_pulloff_value,
                          crimp_configuration.crimp_height,
                          crimp_configuration.crimp_height_iso,
                          crimp_configuration.crimp_width,
                          crimp_configuration.crimp_width_iso,

                          crimp_configuration.i_crimp_height,
                          crimp_configuration.i_crimp_height_iso,
                          crimp_configuration.i_crimp_width,
                          crimp_configuration.i_crimp_width_iso
                      ]

      }
    end
    p.to_stream.read
  end
end

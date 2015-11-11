class MeasuredValueRecord < ActiveRecord::Base


  def self.to_xlsx measured_value_records
    p = Axlsx::Package.new

    wb = p.workbook
    wb.add_worksheet(:name => "sheet1") do |sheet|
      sheet.add_row ["序号", "订单号", "机器号", "端子号", "创建日期", "压接高度 1", "压接高度 2", "压接高度 3", "压接高度 4", "压接高度 5", "压接宽度", "绝缘压接高度", "绝缘压接宽度", "最小拉力值", "备注"]
      measured_value_records.each_with_index { |measured_value_record, index|
        sheet.add_row [
                          index+1,
                          measured_value_record.production_order_id,
                          measured_value_record.machine_id,
                          measured_value_record.part_id,
                          measured_value_record.created_at.nil? ? '' : measured_value_record.created_at.localtime.strftime('%Y-%m-%d %H:%M:%S'),
                          measured_value_record.crimp_height_1,
                          measured_value_record.crimp_height_2,
                          measured_value_record.crimp_height_3,
                          measured_value_record.crimp_height_4,
                          measured_value_record.crimp_height_5,
                          measured_value_record.crimp_width,
                          measured_value_record.i_crimp_heigth,
                          measured_value_record.i_crimp_width,
                          measured_value_record.pulloff_value,
                          measured_value_record.note
                      ]

      }
    end
    p.to_stream.read
  end
end
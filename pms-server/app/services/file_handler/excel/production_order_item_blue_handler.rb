module FileHandler
  module Excel
    class ProductionOrderItemBlueHandler<Base
      HEADERS=['No.', '任务号', '状态', '投卡看板码', '看板', '总成号', 'Kanban 量', 'Kanban 捆扎', '生产量', '投卡时间',
               '销卡时间', '销卡员工', '销卡看板码']

      def self.export(items)
        msg = Message.new
        begin
          tmp_file = full_tmp_path("BlueItem.xlsx")

          p = Axlsx::Package.new
          p.workbook.add_worksheet(:name => "Basic Worksheet") do |sheet|
            sheet.add_row HEADERS
            items.each_with_index do |item,i|
              sheet.add_row [
                                 i+1,
                                 item.nr,
                                 ProductionOrderItemState.display(item.state),
                                 item.code,
                                 item.kanban.nil? ? '':item.kanban.nr,
                                 item.kanban.nil? ? '':item.kanban.product.nr,
                                 item.kanban_qty,
                                 item.kanban_bundle,
                                 item.produced_qty,
                                 item.created_at.localtime,
                                 item.terminated_at.nil? ? '':item.terminated_at.localtime,
                                 item.terminate_user,
                                 item.terminated_kanban_code
                            ], types: [:string, :string, :string, :string, :string, :string, :string, :string, :string, :string, :string, :string, :string]
            end
          end

          p.use_shared_strings = true
          p.serialize(tmp_file)

          msg.result =true
          msg.content =tmp_file
        rescue => e
          msg.content =e.message
        end
        msg
      end
    end
  end
end
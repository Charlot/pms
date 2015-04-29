module Enum
  class PageInfo
    @@models = {KANBAN: "KANBAN", MACHINE: "机器", MEASURE_UNIT: "单位", PRODUCTION_ORDER: "生产订单",
                PRODUCTION_ORDER_ITEM: "生产任务", PART: "零件", PART_BOM: "零件Bom",
                PROCESS_TEMPLATE: "Routing模板", PROCESS_ENTITY: "Routing", RESOURCE_GROUP_MACHINE: "机器组",
                RESOURCE_GROUP_TOOL: "模具组", TOOL: "模具", SETTING: "设置", MASTER_BOM_ITEM: 'Master BOM',
                PART_POSITION: "Cutting原材料库存",
                DEPARTMENT: "部门",WAREHOUSE: "仓库",STORAGE:"库存",POSITION:"库位",
                OEE_CODE: "OeeCode",MACHINE_TYPE: "机器类型",
                MACHINE_TIME_RULE: "机器工时规则"
    }

    @@actions = ["new", "index", "show", "edit", "import", "panel",'transport']

    class<<self
      @@models.each { |k, v|
        method_name = k.to_s.split("_").map(&:capitalize).join
        #puts "#{method_name}".blue
        define_method(method_name.downcase.to_sym) {
          v
        }
        @@actions.each { |action|
          m = k.to_s.split("_").map(&:capitalize).join
          #puts "#{m}_#{action}".red
          define_method("#{m}_#{action}".to_sym) {
            model = self.send(m.downcase)
            action_content(model, action)
          }
        }
      }
    end

    def self.action_content(model, action)
      case action
        when "new"
          "新建#{model}"
        when "index"
          "#{model}列表"
        when "show"
          "#{model}详情"
        when "edit"
          "编辑#{model}"
        when "import"
          "导入#{model}"
        when 'state_export'
          "状态导出#{model}"
        when 'import_to_get_kanban_list'
          "获取看板列表"
        when "panel"
          "#{model}控制面板"
        when 'transport'
          case model
            when 'Master BOM'
              "订单BOM转换"
            else
              'N/A'
          end
        else
          "N/A"
      end
    end
  end
end
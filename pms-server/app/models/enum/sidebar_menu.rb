module Enum
  class SidebarMenu
    @@sidebar_menu = {
        KANBAN: {name: PageInfo.kanban, actions: ["new", "index", "import"]},
        PRODUCTION_ORDER: {name: PageInfo.productionorder, actions: ["new", "index"]},
        PRODUCTION_ORDER_ITEM: {name: PageInfo.productionorderitem, actions: ["new", "index","state_export"]},
        PART: {name: PageInfo.part, actions: ["new", "index", "import"]},
        MEASURE_UNIT: {name: PageInfo.measureunit, actions: ["new", "index"]},
        PART_BOM: {name: PageInfo.partbom, actions: ["new", "index", "import"]},
        PROCESS_TEMPLATE: {name: PageInfo.processtemplate, actions: ["new", "index", "import"]},
        PROCESS_ENTITY: {name: PageInfo.processentity, actions: ["new", "index"]},
        MACHINE: {name: PageInfo.machine, actions: ["new", "index", "import"]},
        RESOURCE_GROUP_MACHINE: {name: PageInfo.resourcegroupmachine, actions: ["new", "index"]},
        RESOURCE_GROUP_TOOL: {name: PageInfo.resourcegrouptool, actions: ["new", "index"]},
        TOOL: {name: PageInfo.tool, actions: ["new", "index", "import"]},
        PART_POSITION: {name: PageInfo.partposition, actions: ["new", "index", "import"]},
        MASTER_BOM_ITEM: {name: PageInfo.masterbomitem, actions: ['new', 'index', 'import','transport']},
        DEPARTMENT: {NAME: PageInfo.department, actions: ['new','index']},
        WAREHOUSE: {NAME: PageInfo.warehouse,actions:['new','index']},
        STORAGE: {NAME: PageInfo.storage,actions:['new','index']},
        OEE_CODE: {NAME: PageInfo.oeecode,actions:['new','index']},
        MACHINE_TYPE: {NAME: PageInfo.machinetype,actions:['new','index']},
        MACHINE_TIME_RULE: {NAME: PageInfo.machinetimerule,actions:['new','index']}
    }

    class<<self
      @@sidebar_menu.each { |k, v|
        method_name = k.to_s.split("_").map(&:capitalize).join
        define_method(method_name.to_sym) {
          v[:actions].map { |val|
            {action: val, content: PageInfo.action_content(v[:name], val)}
          }
        }
      }
    end
  end
end

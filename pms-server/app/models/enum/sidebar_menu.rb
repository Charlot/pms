module Enum
class SidebarMenu
  @@sidebar_menu = {
      KANBAN: {name:PageInfo.kanban,actions:["new", "index", "import"]},
      PRODUCTION_ORDER: {name:PageInfo.productionorder,actions:["new", "index"]},
      PRODUCTION_ORDER_ITEM: {name:PageInfo.productionorderitem,actions:["new", "index"]},
      PART: {name:PageInfo.part,actions:["new", "index", "import"]},
      MEASURE_UNIT: {name:PageInfo.measureunit,actions:["new", "index"]},
      PART_BOM: {name:PageInfo.partbom,actions:["new", "index","import"]},
      PROCESS_TEMPLATE:{name:PageInfo.processtemplate,actions: ["new", "index", "import"]},
      PROCESS_ENTITY: {name:PageInfo.processentity,actions:["new", "index"]},
      MACHINE: {name:PageInfo.machine,actions:["new","index","import"]}
  }

  class<<self
    @@sidebar_menu.each { |k,v|
      method_name = k.to_s.split("_").map(&:capitalize).join
      define_method(method_name.to_sym) {
        v[:actions].map { |val|
          {action: val, content: PageInfo.action_content(v[:name],val)}
        }
      }
    }
  end
end
  end
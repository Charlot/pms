module Enum
  class SidebarMenu
    @@default_roles=['av', 'admin', 'system']
    @@all_roles=['av', 'admin', 'system', 'kanban']
    @@sidebar_menu = {
        KANBAN: {name: PageInfo.kanban,
                 actions: ["new", "index", "import", 'import_lock', 'import_unlock', 'import_to_get_kanban_list', 'import_update_base'],
                 roles: {
                     import_to_get_kanban_list: ['av', 'admin', 'system', 'kanban'],
                 }
        },
        PRODUCTION_ORDER: {name: PageInfo.productionorder, actions: ["index"],
                           roles: {
                               new: @@all_roles,
                               index: @@all_roles
                           }},
        PRODUCTION_ORDER_ITEM: {name: PageInfo.productionorderitem, actions: ["index", "state_export"],
                                roles: {
                                    new: @@all_roles,
                                    index: @@all_roles,
                                    state_export: @@all_roles
                                }},
        PRODUCTION_ORDER_BLUE: {name: PageInfo.productionorderblue, actions: ["index"],
                                roles: {
                                    new: @@all_roles,
                                    index: @@all_roles
                                }},
        PRODUCTION_ORDER_ITEM_BLUE: {name: PageInfo.productionorderitemblue, actions: ["index"],
                                     roles: {
                                         new: @@all_roles,
                                         index: @@all_roles,
                                     }},

        PART: {name: PageInfo.part, actions: ["new", "index", "import", 'import_update']},
        MEASURE_UNIT: {name: PageInfo.measureunit, actions: ["new", "index"]},
        PART_BOM: {name: PageInfo.partbom, actions: ["new", "index", "import"]},
        PROCESS_TEMPLATE: {name: PageInfo.processtemplate, actions: ["new", "index", "import"]},
        PROCESS_ENTITY: {name: PageInfo.processentity, actions: ["new", "index"]},
        MACHINE: {name: PageInfo.machine, actions: ["new", "index", "import"]},
        RESOURCE_GROUP_MACHINE: {name: PageInfo.resourcegroupmachine, actions: ["new", "index"]},
        RESOURCE_GROUP_TOOL: {name: PageInfo.resourcegrouptool, actions: ["new", "index"]},
        TOOL: {name: PageInfo.tool, actions: ["new", "index", "import"]},
        PART_POSITION: {name: PageInfo.partposition, actions: ["index", "import"]},
        MASTER_BOM_ITEM: {name: PageInfo.masterbomitem, actions: ['new', 'index', 'import', 'transport', 'export']},
        DEPARTMENT: {NAME: PageInfo.department, actions: ['new', 'index']},
        WAREHOUSE: {NAME: PageInfo.warehouse, actions: ['new', 'index']},
        STORAGE: {NAME: PageInfo.storage, actions: ['new', 'index']},
        OEE_CODE: {NAME: PageInfo.oeecode, actions: ['new', 'index']},
        MACHINE_TYPE: {NAME: PageInfo.machinetype, actions: ['new', 'index']},
        MACHINE_TIME_RULE: {NAME: PageInfo.machinetimerule, actions: ['new', 'index', 'import']},
        USER: {NAME: PageInfo.user, actions: ['new', 'index']},
        POSITION: {NAME: PageInfo.position, actions: ['new', 'index']},
        CRIMP_CONFIGURATION: {name: PageInfo.crimpconfiguration, actions: ["new", "index", "import"]},
        WIRE_GROUP: {name: PageInfo.wiregroup, actions: ["new", "index", "import"]},
        MEASURED_VALUE_RECORD: {name: PageInfo.measuredvaluerecord, actions: ["new", "index", "import"]}
    }

    class<<self
      @@sidebar_menu.each { |k, v|
        method_name = k.to_s.split("_").map(&:capitalize).join
        define_method(method_name.to_sym) {
          v[:actions].map { |val|
            {action: val, content: PageInfo.action_content(v[:name], val), roles: v[:roles].nil? ? @@default_roles : (v[:roles][val.to_sym]||@@default_roles)}
          }
        }
      }
    end
  end
end

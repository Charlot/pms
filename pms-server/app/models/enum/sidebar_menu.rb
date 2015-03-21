class SidebarMenu
  @@menu = {
      KANBAN: {name:"Kanban",actions:["new", "index", "import"]},
      PRODUCTION_ORDER: {name:"生产订单",actions:["new", "index"]},
      PRODUCTION_ORDER_ITEM: {name:"生产任务",actions:["new", "index"]},
      PART: {name:"零件",actions:["new", "index", "import"]},
      MEASURE_UNIT: {name:"单位",actions:["new", "index"]},
      PART_BOM: {name:"零件BOM",actions:["new", "index"]},
      PROCESS_TEMPLATE:{name:"Routing模板",actions: ["new", "index", "import"]},
      PROCESS_ENTITY: {name:"Routing",actions:["new", "index"]}
  }

  class<<self
    @@menu.each { |k,v|
      method_name = k.to_s.split("_").map(&:capitalize).join
      define_method(method_name.to_sym) {
        v[:actions].map { |val|
          {action: val, content: content(v[:name],val)}
        }
      }
    }
  end

  def self.content(model,action)
    case action
    when "new"
      "新建#{model}"
    when "index"
      "#{model}列表"
    when "import"
      "导入#{model}"
    else
      "N/A"
    end
  end
end
class KanbanDispatchTest
  def self.test
    kb=Kanban.first
    node=MachineCombination.init_node_by_kanban(kb)
    puts node.to_json
    list=MachineCombination.load_combinations
    puts list.to_json
    puts list.match(node)

  end
end

KanbanDispatchTest.test
class MachineCombination < ActiveRecord::Base
  belongs_to :machine
  delegate :nr,to: :machine,prefix: true,allow_nil: true

  MATCH_INDEX={w1: 0, t1: 1, t2: 2, s1: 3, s2: 4, wd1: 5, w2: 6, t3: 7, t4: 8, s3: 9, s4: 10, wd2: 11}
  PROCESS_ENTITY_MATCH_MAP={wire_nr: 0, t1: 1, t2: 2, s1: 3, s2: 4, w2: 6, t3: 7, t4: 8, s3: 9, s4: 10}

  before_save :set_match_index
  before_save :set_complexity

  def self.load_combinations
    list=MachineCombinationList.new(nodes: [])
    order(complexity: :desc).all.each do |c|
      items=[]
      MATCH_INDEX.each do |k, v|
        items[v]=c.send(k)
      end
      list.nodes<<MachineCombinationNode.new(key: c.id, machine_id: c.machine_id, match_start_index: c.match_start_index, match_end_index: c.match_end_index, items: items)
    end
    return list
  end

  # kanban is write kanban
  def self.init_node_by_kanban(kanban)
    node=MachineCombinationNode.new(items: Array.new(MATCH_INDEX.length))
    process_entity=kanban.process_entities.first
    template=process_entity.process_template
    # begin for count
    item_index_end_count=2
    # end for count
    PROCESS_ENTITY_MATCH_MAP.keys.each do |k|
      if template.send("field_#{k}")
        node.match_start_index = PROCESS_ENTITY_MATCH_MAP[k] if node.match_start_index.nil?
        if (value =process_entity.send("value_#{k}")).blank?
          item_index_end_count+=1
        else
          item_index_end_count=2
          node.items[PROCESS_ENTITY_MATCH_MAP[k]]=value
        end
      else
        item_index_end_count+=1
      end
    end
    puts "#{item_index_end_count}"
    node.match_end_index = MATCH_INDEX.length-item_index_end_count-1
    return node
  end

  private
  def set_match_index
    # set match start index
    MATCH_INDEX.keys.each do |k|
      unless self.send(k).nil?
        self.match_start_index=MATCH_INDEX[k]
        break
      end
    end

    # set match end index
    MATCH_INDEX.keys.reverse.each do |k|
      unless self.send(k).nil?
        self.match_end_index=MATCH_INDEX[k]
        break
      end
    end

    # take care of blank values
    self.match_start_index=self.match_end_index=0 if self.match_start_index>self.match_end_index
  end

  def set_complexity
    MATCH_INDEX.keys.each do |k|
      self.complexity+=1 unless self.send(k).blank?
    end
  end
end


class MachineCombinationList< BaseClass
  attr_accessor :nodes

  def match(node)
	  puts '------------------------------'
	  p node
	  p node.items.length
      puts '*************************' 
	  self.nodes.each_with_index do |n,j|
	      end_index=node.items.length-1
		
		  p n if n.machine_id==8 && n.items[0]==355


		  (0..end_index).each{|i|
			  if node.items[i].to_s != n.items[i].to_s
				  break
			  elsif i < end_index
			  elsif i== end_index
				  return n
			  end
		  }
	  end
    self.nodes.each_with_index do |n, j|
  	  	
      match_start_index =(node.match_start_index>n.match_start_index) ? node.match_start_index : n.match_start_index
      match_end_index =(node.match_end_index<n.match_end_index) ? node.match_end_index : n.match_end_index
      puts "%%%%#{node.to_json}"
      puts "#####{n.to_json}"
       puts "&&&.#{j}.#{n.key}.start compare:#{match_start_index}:#{match_end_index}".colorize(:blue)
      (match_start_index..match_end_index).each { |i|
         puts "**#{i}---#{node.items[i]}:#{n.items[i]}"
        if !node.items[i].nil? && !n.items[i].nil?
          if node.items[i].to_s!=n.items[i].to_s
             puts "break------#{node.items[i]}:#{n.items[i]}---------#{node.items[i].class}:#{n.items[i].class}----------------"
            break
          elsif i< match_end_index
             puts "EQUAL:#{i}-------------------------------"
            # return false
          elsif i==match_end_index
            puts "success : #{n.key}--key-------------------------".colorize(:yellow)
           # raise 'no'
			return n
          end
        end
      }
    end
    # puts 'fail :  -------------------------'.colorize(:red)

    return nil
  end
end

class MachineCombinationNode<BaseClass
  attr_accessor :key, :machine_id, :match_start_index, :match_end_index, :items

  def default
    {match_start_index: 0, match_end_index: 5}
  end
end


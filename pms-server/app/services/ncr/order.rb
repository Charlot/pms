module Ncr
  class Order
    attr_accessor :production_order, :type

    def initialize(production_order=nil, type=ProductionOrderType::WHITE)
      self.production_order=production_order
      self.type=type
    end

    def distribute
      msg=Message.new
      begin

        if self.type ==ProductionOrderType::WHITE
          ProductionOrderItem.transaction do
            items=ProductionOrderItem.for_distribute(self.production_order)
            items.each do |item|
              # puts item.to_json
              begin
                # response=RestClient.post(write_order_api(item), {params: post_params(item).to_json},
                #                          accept: :json)
                # rb=JSON.parse(response.body)
                # if rb['Result']
                # if (kb=Kanban.find_by_id(item.kanban_id)) && kb.quantity<200
                item.update_attributes(state: ProductionOrderItemState::DISTRIBUTE_SUCCEED)
                  # end
                  # else
                  #   item.update_attributes(state: ProductionOrderItemState::DISTRIBUTE_FAIL, message: rb['Content'])
                  # end
                  # puts JSON.parse(response.body)['Result'].class
              rescue => e
                if e.is_a?(Errno::ECONNREFUSED)
                  item.update_attributes(state: ProductionOrderItemState::DISTRIBUTE_FAIL, message: e.message)
                end
              end
            end
          end
        elsif self.type =ProductionOrderType::BLUE
          ProductionOrderItemBlue.transaction do
            order=ProductionOrderBlue.new
            i=0
            ProductionOrderItemBlue.for_distribute.each do |item|
              item.update_attributes(state: ProductionOrderItemState::DISTRIBUTE_SUCCEED)
              order.production_order_item_blues<<item
              i+=1
            end

            order.save
            self.production_order=order
          end
        end
        msg.result=true
      rescue => e
        msg.result =false
        msg.content =e.message
        # raise(e)
      end
      msg
    end

    def post_params(item)
      {
          file_name: json_file_name(item)+'.json',
          order_nr: self.production_order.nr,
          item_nr: item.nr,
          file_json_content: json_order_item_content(item)
      }
    end

    def write_order_api(item)
      URI.encode "http://#{item.machine.ip}:9000/ncr/receive_order"
    end

    def json_file_name(item)
      "#{item.nr}"
    end

    # sng: 索尼格
    def json_order_item_content(item, machine_type=nil, mirror=false)
      kanban=item.kanban
      process_entity=kanban.process_entities.first
      # template=process_entity.process_template
      wire=Part.find_by_id(process_entity.value_wire_nr)
      unless mirror
        t1=Part.find_by_id(process_entity.value_t1)
        t2=Part.find_by_id(process_entity.value_t2)
        s1=Part.find_by_id(process_entity.value_s1)
        s2=Part.find_by_id(process_entity.value_s2)

        strip1=process_entity.t1_strip_length
        strip2=process_entity.t2_strip_length
      else
        t2=Part.find_by_id(process_entity.value_t1)
        t1=Part.find_by_id(process_entity.value_t2)
        s2=Part.find_by_id(process_entity.value_s1)
        s1=Part.find_by_id(process_entity.value_s2)

        strip1=process_entity.t2_strip_length
        strip2=process_entity.t1_strip_length
      end

      if self.production_order.nil?
        self.production_order=item.production_order
      end

      json={
          production_order_id: self.production_order.id,
          production_order_nr: self.production_order.nr,
          item_id: item.id,
          item_nr: item.nr,
          wire_nr: wire.nr,
          wire_custom_nr: wire.custom_nr,
          wire_desc: wire.description,
          wire_length: process_entity.value_wire_qty_factor
      }

      unless t1.nil?
        tool1=Tool.where(part_id: t1.id).first
        json=json.merge({
                            t1_nr: t1.nr,
                            t1_custom_nr: t1.custom_nr,
                            t1_strip_length: strip1,
                            t1_tool: tool1.nil? ? nil : tool1.nr
                        })
      end

      unless t2.nil?
        tool2=Tool.where(part_id: t2.id).first

        json=json.merge({
                            t2_nr: t2.nr,
                            t2_custom_nr: t2.custom_nr,
                            t2_strip_length: strip2,
                            t1_tool: tool2.nil? ? nil : tool2.nr
                        })
      end

      unless s1.nil?
        json=json.merge({
                            s1_nr: s1.nr
                        })

      end


      unless s2.nil?
        json=json.merge({
                            s2_nr: s2.nr
                        })

      end

      # job
      json[:job]={
          NewJob: {
              Job: "J_#{item.nr}",
              ArticleKey: "A_#{item.nr}",
              TotalPieces: kanban.quantity,
              BatchSize: kanban.bundle,
              Name: "J_#{item.nr}",
              Hint: " Cutting Job: #{item.nr}. Cutting Order: #{self.production_order.nr}. Kanban #{kanban.nr}. Bundle quantity: #{kanban.bundle}. Total quantity: #{kanban.quantity}."
          }
      }

      pull_off_length1=nil
      if t1.nil? && s1.nil?
        begin
          pull_off_length1 =strip1.to_f/2
        rescue => e
          puts e.message
        end
      end

      pull_off_length2=nil
      if t2.nil? && s2.nil?
        begin
          pull_off_length2 =strip2.to_f/2
        rescue => e
          puts e.message
        end
      end
      # article
      json[:article]={
          NewArticle: {
              ArticleKey: "A_#{item.nr}",
              ArticleGroup: 'Group0',
              Name: "A_#{item.nr}",
              Hint: "A_#{item.nr}"
          },
          NewLeadSet1: {
              WireKey: wire.nr,
              WireLength: process_entity.value_wire_qty_factor,
              StrippingLength: "#{strip1}, #{strip2}",
              # PulloffLength: "#{process_entity.t1_strip_length}, #{process_entity.t2_strip_length}",
              PulloffLength: "#{pull_off_length1}, #{pull_off_length2}",
              SealKey: "#{s1.nil? ? '' : s1.nr}, #{s2.nil? ? '' : s2.nr}",
              TerminalKey: "#{t1.nil? ? '' : t1.nr}, #{t2.nil? ? '' : t2.nr}"
          }
      }

      # wire
      json[:wire]={
          NewWire: {
              WireKey: wire.nr,
              WireGroup: 'Group0',
              ElectricalSizeMM2: wire.cross_section==0 ? '' : wire.cross_section, #0605leoni charlot #process_entity.value_wire_qty_factor,
              Diameter: wire.cross_section==0 ? '' : wire.cross_section,
              Color: 'RD',
              Name: wire.nr,
              Hint: wire.nr
          }
      }

      # terminal
      unless t1.nil?
        json[:terminal1]={
            NewTerminal: {
                TerminalKey: t1.nr,
                TerminalGroup: 'Group0',
                StrippingLength: strip1,
                Name: t1.nr,
                Hint: 't1 description'
            }
        }
      end

      unless t2.nil?
        json[:terminal2]={
            NewTerminal: {
                TerminalKey: t2.nr,
                TerminalGroup: 'Group0',
                StrippingLength: strip2,
                Name: t2.nr,
                Hint: 't2 description'
            }
        }
      end

      # seal
      unless s1.nil?
        json[:seal1]={
            NewSeal: {
                SealKey: s1.nr,
                SealGroup: 'Group0',
                Color: 'YE',
                Name: s1.nr,
                Hint: 's1 description'
            }
        }
      end

      unless s2.nil?
        json[:seal2]={
            NewSeal: {
                SealKey: s2.nr,
                SealGroup: 'Group0',
                Color: 'YE',
                Name: s2.nr,
                Hint: 's2 description'
            }
        }
      end

      puts "----------------------#{machine_type}".yellow
      puts json
      if machine_type=='Komax333'
        puts '------------------'.yellow
        # remove Name & Hint
        json.each do |k, v|
          puts k

          puts v
          puts v.class
          if v.is_a?(Hash)
            v.values.each do |vv|
              puts '---------------------'.blue
              puts vv
              puts vv.class
              puts '---------------------'.blue
              vv.delete(:Name)
              vv.delete(:Hint)

              puts '---------------------'.red
              puts vv
              puts vv.class
              puts '---------------------'.red
            end
          end
        end
      end

      puts json

      # raise
      # puts "---------------------"
      # puts json.to_json
      # puts "------------------------"
      json
    end
  end
end
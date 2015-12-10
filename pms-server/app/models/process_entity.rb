class ProcessEntity < ActiveRecord::Base
  validates :nr, presence: {message: 'nr cannot be blank'}
  validates_uniqueness_of :nr, :scope => :product_id
  include PartBomable


  belongs_to :process_template
  belongs_to :workstation_type
  belongs_to :cost_center
  belongs_to :product, class_name: 'Part'
  has_many :kanban_process_entities, dependent: :destroy
  has_many :kanbans, through: :kanban_process_entities
  has_many :process_parts, dependent: :destroy
  has_many :parts, through: :process_parts
  has_many :custom_values, as: :custom_fieldable, dependent: :destroy

  delegate :custom_fields, to: :process_template, allow_nil: true
  delegate :nr, to: :product, prefix: true, allow_nil: true
  delegate :code, to: :process_template, prefix: true, allow_nil: true
  delegate :type, to: :process_template, prefix: true, allow_nil: true

  acts_as_customizable

  has_paper_trail

  scoped_search on: :nr
  scoped_search in: :product, on: :nr
  scoped_search in: :custom_values, on: :value, ext_method: :find_by_parts

  # after_create :build_process_parts

  def self.find_by_parts key, operator, value
    parts = Part.where("nr LIKE '%_#{value}%'").map(&:id)

    if parts.count > 0
      process = ProcessEntity.joins(custom_values: :custom_field).where(
          "custom_values.value IN (#{parts.join(',')}) AND custom_fields.field_format = 'part'"
      ).map(&:id)
      if process.count > 0
        return {conditions: "process_entities.id IN(#{process.join(',')})"}
      end
      {conditions: "process_entities.nr like '%#{value}%'"}
    end
    {conditions: "process_entities.nr LIKE '%#{value}%'"}
  end

  def template_fields
    a = []
    if self.process_template_type == ProcessType::SEMI_AUTO
      a = self.custom_fields.collect do |cf|
        if cf.name == "default_wire_nr"
          next
        end
        cv = self.custom_values.where(custom_field_id: cf.id).first

        if cf.field_format == 'part'
          if cv
            wire = Part.find_by_id(cv.value)
            if wire
              pp = process_parts.where({part_id: wire.id}).first
              "#{wire.parsed_nr}|#{pp.quantity if pp}"
            else
              ""
            end
          else
            ""
          end
        else
          if cv
            cv.value
          else
            ""
          end
        end
      end
    else
      a= ["错误"]
    end
    puts a.to_json
    puts a.compact.to_json
    a.compact
  end

  # 目前只有6中操作方式
  # CC: 两端压端子
  # CW: 一端压端子，一端剥线
  # CS: 一端压端子，一端套防水圈
  # SW: 一端套防水圈，一端剥线
  # SS: 两端套防水圈
  # WW: 两端剥线
  # 下面的逻辑请对照上面的6中操作方式查看
  # 我问过徐工的逻辑是，
  # 压了端子，一定要剥线，
  # 套了防水圈，也是一定要剥线
  # 所以你可以看到我下面的判断的“先后顺序”
  def oee_code(oee = "")
    case oee
      when ""
        if value_t1 || value_t2
          oee = "C"
          oee_code(oee)
        elsif value_s1 || value_s2
          oee = "S"
          oee_code(oee)
        elsif value_t1_strip_length || value_t2_strip_length
          oee = "W"
          oee_code(oee)
        else
          oee << "-"
        end
      when "C"
        if value_t1 && value_t2
          oee << "C"
        elsif value_s1 || value_s2
          oee << "S"
        elsif ((value_t1.nil? && value_t1_strip_length) || (value_t2.nil? && value_t2_strip_length))
          oee << "W"
        else
          oee << "-"
        end
      when "W"
        if value_t1_strip_length && value_t2_strip_length
          oee << "W"
        elsif ((value_t1_strip_length.nil? && value_s1) || (value_t2_strip_length.nil? && value_s2))
          oee << "S"
        else
          oee << "-"
        end
      when "S"
        if value_s1 && value_s2
          oee << "S"
        elsif ((value_s1.nil? && value_t1_strip_length) || (value_s2.nil? && value_t2_strip_length))
          oee << "W"
        else
          oee << "-"
        end
    end
    oee
  end

  #
  def wire
    if self.value_default_wire_nr && (part = Part.find_by_id(self.value_default_wire_nr))
      return part
    end
    nil
  end

  def parsed_wire_nr
    wire.parsed_nr if wire
  end

  def wire_component
    if self.value_wire_nr && (part = Part.find_by_id(self.value_wire_nr))
      return part
    end
    nil
  end

  def custom_field_type
    puts '***************************************8'
    puts "#{self.process_template_id}_#{ProcessTemplate.name}"
    puts '***************************************8'

    @custom_field_type || (self.process_template_id.nil? ? nil : "#{self.process_template_id}_#{ProcessTemplate.name}")
  end


  def process_part_quantity_by_cf(cf_name)
    if quantity_cf_name=ProcessTemplateAuto.process_part_quantity_field(cf_name)
      self.send(quantity_cf_name)
    end
  end

  # for auto process entity
  def t1_strip_length
    @t1_strip_length=if self.value_t1_default_strip_length && (self.value_t1_default_strip_length.to_f!=0)
                       self.value_t1_default_strip_length
                     else
                       self.value_t1_strip_length
                     end
  end


  def t2_strip_length
    # @t2_strip_length||=(self.value_t2_default_strip_length || self.value_t2_strip_length )
    @t2_strip_length=if self.value_t2_default_strip_length && (self.value_t2_default_strip_length.to_f!=0)
                       self.value_t2_default_strip_length
                     else
                       self.value_t2_strip_length
                     end
  end

  def template_text
    template=self.process_template
    cfs=template.custom_fields
    cfvs=self.custom_field_values
    if template.template
      self.process_template.template.gsub(/{\d+}/).each do |v|
        if cf=cfs.detect { |f|
          f.id.to_i==v.scan(/{(\d+)}/).map(&:first).first.to_i }
          cfv=cfvs.detect { |v| v.custom_field_id==cf.id }
          CustomFieldFormatType.part?(cf.field_format) ? ((part=Part.find_by_id(cfv.value)).nil? ? '' : part.parsed_nr) : (cfv.value.nil? ? '' : cfv.value)
        else
          'ERROR'
        end
      end
    else
      ''
    end
  end

  def parse_process_entity
    puts '------------------parse_process_entity--------------------'
    args = {}
    process_types = BlueKanbanTimeRule.get_process_types(self.process_template.code)

    if ["2210", "2211", "2212", "2411", "2220", "2240", "2221", "2222"].include? self.process_template.code
      # args[:process_type] = process_types.first
      # args[:description] = "2 pcs wire"
      # # case self.process_template.code
      # #   when "2210"
      # #     cv_1 = self.custom_values.first.value
      # #     cv_2 = self.custom_values.second.value
      # #     length1 = ProcessEntity.joins({custom_values: :custom_field}).where({custom_fields: {name: 'default_wire_nr'}, custom_values: {value: cv_1}, product_id: self.product_id}).first.value_wire_qty_factor.to_f
      # #     length2 = ProcessEntity.joins({custom_values: :custom_field}).where({custom_fields: {name: 'default_wire_nr'}, custom_values: {value: cv_2}, product_id: self.product_id}).first.value_wire_qty_factor.to_f
      # #   when "2211"
      # #     cv_1 = self.custom_values.first.value
      # #     cv_3 = self.custom_values.third.value
      # #     length1 = ProcessEntity.joins({custom_values: :custom_field}).where({custom_fields: {name: 'default_wire_nr'}, custom_values: {value: Part.where("nr like '%#{cv_1}%'")}, product_id: self.product_id}).first.value_wire_qty_factor.to_f
      # #     length2 = ProcessEntity.joins({custom_values: :custom_field}).where({custom_fields: {name: 'default_wire_nr'}, custom_values: {value: cv_3}, product_id: self.product_id}).first.value_wire_qty_factor.to_f
      # #   when "2212"
      # #     cv_1 = self.custom_values.first.value
      # #     cv_3 = self.custom_values.third.value
      # #     length1 = ProcessEntity.joins({custom_values: :custom_field}).where({custom_fields: {name: 'default_wire_nr'}, custom_values: {value: Part.where("nr like '%#{cv_1}%'")}, product_id: self.product_id}).first.value_wire_qty_factor.to_f
      # #     length2 = ProcessEntity.joins({custom_values: :custom_field}).where({custom_fields: {name: 'default_wire_nr'}, custom_values: {value: Part.where("nr like '%#{cv_3}%'")}, product_id: self.product_id}).first.value_wire_qty_factor.to_f
      # #   when "2411"
      # #     cv_1 = self.custom_values.first.value
      # #     cv_3 = self.custom_values.third.value
      # #     length1 = ProcessEntity.joins({custom_values: :custom_field}).where({custom_fields: {name: 'default_wire_nr'}, custom_values: {value: Part.where("nr like '%#{cv_1}%'")}, product_id: self.product_id}).first.value_wire_qty_factor.to_f
      # #     length2 = ProcessEntity.joins({custom_values: :custom_field}).where({custom_fields: {name: 'default_wire_nr'}, custom_values: {value: cv_3}, product_id: self.product_id}).first.value_wire_qty_factor.to_f
      # # end
      #
      # if length1 > length2
      #   max = length1
      #   min = length2
      # else
      #   max = length2
      #   min = length1
      # end
      #
      # if max < 1500
      #   args[:detail] = "wire length is less than 1.5m"
      # elsif min >= 1500
      #   args[:detail] = "2 sides wire length are more than 1.5m"
      # else
      #   args[:detail] = "1 side wire length is more than 1.5m"
      # end

      args[:process_type] = process_types.first
      args[:description] = 'several wires'
      args[:detail] = "2T/8T-continuous terminal"

    elsif ["2110", "2115", "2116"].include? self.process_template.code
      args[:process_type] = process_types.first
      args[:description] = "Strip"

    elsif ["2150"].include? self.process_template.code
      args[:process_type] = process_types.first
      args[:description] = "only cutting"
      args[:detail] = self.custom_field_values[1].value

    elsif ["2165"].include? self.process_template.code
      args[:process_type] = process_types.first
      args[:description] = "Twisting"
      args[:detail] = self.custom_field_values[6].value

    elsif ["2160"].include? self.process_template.code
      args[:process_type] = process_types.first
      args[:description] = "Twisting(2 wires)"
      args[:detail] = self.custom_field_values[3].value

    elsif ["2170"].include? self.process_template.code
      args[:process_type] = process_types.first
      args[:description] = "cut wire and sort the wire"
      args[:detail] = "for RBA"

    elsif ["2200", "2207", "2208", "2250", "2251"].include? self.process_template.code
      args[:process_type] = process_types.first
      args[:description] = 'single wire'
      args[:detail] = 'continuous terminal-general crimping'

    elsif ["2209"].include? self.process_template.code
      args[:process_type] = process_types.first
      args[:description] = 'single wire and seal'
      args[:detail] = '2T/8T-continuous terminal'

    elsif ["2020", "5210"].include? self.process_template.code
      args[:process_type] = process_types.first
      args[:description] = 'corrugation pipe cutting'
      args[:detail] = self.custom_field_values[1].value

    elsif ["2300", "2301"].include? self.process_template.code
      args[:process_type] = process_types.first

    elsif ["2410"].include? self.process_template.code
      args[:process_type] = process_types.first

      left_max = 0.0
      right_max = 0.0
      description_count = 0
      self.custom_field_values.each_with_index do |value, index|
        puts "111--------#{value}----------------#{index}--------------#{self.nr}---------------"
        unless value.to_s.blank?
          if (0...8).include? index
            description_count += 1
            length = ProcessEntity.joins({custom_values: :custom_field}).where({custom_fields: {name: 'default_wire_nr'}, custom_values: {value: "#{value}"}, product_id: self.product_id}).first.nil? ? 0.0 : ProcessEntity.joins({custom_values: :custom_field}).where({custom_fields: {name: 'default_wire_nr'}, custom_values: {value: "#{value}"}, product_id: self.product_id}).first.value_wire_qty_factor.to_f
            left_max = left_max > length ? left_max : length
          elsif (9..16).include? index
            description_count += 1
            length = ProcessEntity.joins({custom_values: :custom_field}).where({custom_fields: {name: 'default_wire_nr'}, custom_values: {value: "#{value}"}, product_id: self.product_id}).first.nil? ? 0.0 : ProcessEntity.joins({custom_values: :custom_field}).where({custom_fields: {name: 'default_wire_nr'}, custom_values: {value: "#{value}"}, product_id: self.product_id}).first.value_wire_qty_factor.to_f
            right_max = right_max > length ? right_max : length
          end
        end
      end

      args[:description] = "#{description_count} pcs wire"

      if left_max < 1500 && right_max < 1500
        args[:detail] = "wire length is less than 1.5m"
      elsif left_max >= 1500 && right_max >= 1500
        args[:detail] = "2 sides wire length are more than 1.5m"
      else
        args[:detail] = "1 side wire length is more than 1.5m"
      end


    elsif ["5200"].include? self.process_template.code
      args[:process_type] = process_types.first
      args[:description] = 'Pull on the pipe'
#############################步骤模板code为5200  的步骤长度都用0mm≤L≤200mm
      args[:detail] = 100

    elsif ["5201", "5205"].include? self.process_template.code
      args[:process_type] = process_types.first
      args[:description] = 'Pull on the pipe'
      args[:detail] = self.custom_field_values[2].value
      ######################################XXX################################################
    elsif ["5202"].include? self.process_template.code
      args[:process_type] = process_types.first
      args[:description] = 'Pull on the pipe'
      args[:detail] = self.custom_field_values[10].value

    elsif ["5300"].include? self.process_template.code
      args[:process_type] = process_types.first

    elsif ["5320"].include? self.process_template.code
      args[:process_type] = process_types.first
      args[:description] = 'Insert the seal'

    elsif ["5420"].include? self.process_template.code
      args[:process_type] = process_types.first
      args[:description] = "Splice taping"
      length1 = Part.where(id: self.custom_field_values[0].value).first.nil? ? 0 : Part.where(id: self.custom_field_values[0].value).first.cross_section.to_f
      length2 = Part.where(id: self.custom_field_values[1].value).first.nil? ? 0 : Part.where(nr: self.custom_field_values[1].value).first.cross_section.to_f

      if length1 > length2
        difference = length1 - length2
      else
        difference = length2 - length1
      end

      if difference < 1
        args[:detail] = "2 wires section gap less than 1mm"
      else
        args[:detail] = "2 wires section gap more than 1mm"
      end

    elsif ["5600", "5400", "5410", "2120", "2151"].include? self.process_template.code
      args[:process_type] = process_types.first
      args[:description] = 'Shiled wire'
      case self.process_template.code
        when "5600"
          args[:detail] = "peel off"
        when "5400"
          args[:detail] = "Shrink the pipe"
        when "5410"
          args[:detail] = "Insert the shrinking pipe"
        when "2120"
          args[:detail] = "Order the wire"
        when "2151"
          args[:detail] = "cut the wire"
      end

    end

    puts '-----------------------'
    puts args
    args
  end

  def get_process_entity_worktime(production_order_item=nil)
    process_enrity_time = 0.000
    if ProcessType.semi_auto?(self.process_template.type)
      process_enrity_time = BlueKanbanTimeRule.get_blue_kanban_process_enrity_time(self.parse_process_entity)
    else
      if production_order_item && (machine=production_order_item.machine) && (machine_type_id = machine.machine_type_id)
      else
        machine_type_id = MachineType.find_by_nr('CC36').id
      end

      if machine_type_id.nil?
        return process_enrity_time
      end

      #根据全自动看的工艺来查找出操作代码
      oee = OeeCode.find_by_nr(self.oee_code)

      if oee.nil?
        return process_enrity_time
      end

      #查找全部满足的全自动工时规则，并且以断线长度升序排序
      timerule = nil
      wire_length_value = self.value_wire_qty_factor.to_f
      timerule = MachineTimeRule.where(["oee_code_id = ? AND machine_type_id = ? AND min_length <= ? AND length > ?", oee.id, machine_type_id, wire_length_value, wire_length_value]).first

      unless timerule.nil?
        process_enrity_time = timerule.time
      end
    end

    process_enrity_time.round(3)
  end

  def get_process_entity_worktime_by_blue
    process_enrity_time = BlueKanbanTimeRule.get_blue_kanban_process_enrity_time(self.parse_process_entity)
  end

  def get_process_entity_worktime_by_white(production_order_item=nil)
    process_enrity_time = 0.000

    if production_order_item && (machine=production_order_item.machine) && (machine_type_id = machine.machine_type_id)
    else
      machine_type_id = MachineType.find_by_nr('CC36').id
    end

    if machine_type_id.nil?
      return process_enrity_time
    end

    #根据全自动看的工艺来查找出操作代码
    oee = OeeCode.find_by_nr(self.oee_code)

    if oee.nil?
      return process_enrity_time
    end

    #查找全部满足的全自动工时规则，并且以断线长度升序排序
    timerule = nil
    wire_length_value = self.value_wire_qty_factor.to_f
    timerule = MachineTimeRule.where(["oee_code_id = ? AND machine_type_id = ? AND min_length <= ? AND length > ?", oee.id, machine_type_id, wire_length_value, wire_length_value]).first

    unless timerule.nil?
      process_enrity_time = timerule.time
    end

    process_enrity_time
  end

  alias :work_time :get_process_entity_worktime

end

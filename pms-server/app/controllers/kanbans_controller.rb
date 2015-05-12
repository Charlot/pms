class KanbansController < ApplicationController
  before_action :set_kanban, only: [:show, :edit, :update, :destroy,
                                    :add_process_entities, :delete_process_entities,
                                    :finish_production, :history, :release, :lock, :discard, :manage_routing]

  # GET /kanbans
  # GET /kanbans.json
  def index
    @kanbans = Kanban.paginate(:page => params[:page])
  end

  # GET /kanbans/1
  # GET /kanbans/1.json
  def show
  end

  # GET /kanbans/new
  def new
    @kanban = Kanban.new
    # authorize(@kanban)
    2.times { @kanban.kanban_process_entities.build }
  end

  # GET /kanbans/1/edit
  def edit
  end

  # POST /kanbans
  # POST /kanbans.json
  def create
    ActiveRecord::Base.transaction do
      @kanban = Kanban.new(kanban_params)
    end
    # authorize(@kanban)
    respond_to do |format|
      if @kanban.save
        format.html { redirect_to @kanban, notice: 'Kanban was successfully created.' }
        format.json { render :show, status: :created, location: @kanban }
      else
        format.html { render :new }
        format.json { render json: @kanban.errors, status: :unprocessable_entity }
      end
    end
  end

  #GET /kanbans/1/manage_routing
  def manage_routing
    #authorize(Kanban)
  end

  #POST /kanbans/1/add_process_entities
  def add_process_entities
    msg = Message.new
    msg.result = false
    if @kanban.process_entities.ids.include?(params[:process_entities])
      msg.content = "Routing已经存在！"
      render json: msg and return
    end

    process_entities = []
    if (process_entities = ProcessEntity.where(id: params[:process_entities])).count != params[:process_entities].count
      msg.content = "Routing未找到"
      render json: msg and return
    end

    create_params = process_entities.collect { |pe| {process_entity_id: pe.id} }

    unless kpes = @kanban.kanban_process_entities.create(create_params)
      msg.content = @kanban.errors.full_messages
      render json: msg
    end

    msg.result = true
    msg.content = kpes
    render json: msg
  end

  # DELETE /kanbans/1/delete_process_entities
  def delete_process_entities
    msg = Message.new
    msg.result = true

    unless (kpes = @kanban.kanban_process_entities.where(process_entity_id: params[:process_entities])).count == params[:process_entities].count
      msg.result = false
      render json: msg and return
    end

    kpes.each { |kpe| kpe.destroy }

    render json: msg
  end

  # PATCH/PUT /kanbans/1
  # PATCH/PUT /kanbans/1.json
  def update
    respond_to do |format|
      puts "======="
      puts kanban_params.to_json
      if @kanban.can_update? && @kanban.update(kanban_params)
        #if @kanban.update(kanban_params)
        format.html { redirect_to @kanban, notice: 'Kanban was successfully updated.' }
        format.json { respond_with_bip(@kanban) }
      else
        format.html { render :edit, notice: 'State Error' }
        format.json { respond_with_bip(@kanban) }
      end
    end
  end

  # DELETE /kanbans/1
  # DELETE /kanbans/1.json
  def destroy
    redirect_to kanbans_url, notice: 'State Error.' and return if @kanban.can_destroy?
    @kanban.destroy
    respond_to do |format|
      format.html { redirect_to kanbans_url, notice: 'Kanban was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  # POST /kanbans/1/finish_production
  # POST /kanbans/1/finish_production.json
  def finish_production
    msg = Message.new
    #end_product = {part_id: @kanban.part_id, quantity: @kanban.quantity}
    #raw_materials = []
    #@kanban.get_raw_materials.each { |raw_material|
    #  raw_materials << {part_id: raw_material.part_id, quantity: raw_material.quantity * @kanban.quantity}
    #}
    #TODO Move storage for both end products and raw materials
    render json: msg
  end

  # GET /kanbans/1/history
  # GET /kanbans/1/history.json
  def history
    @versions = @kanban.versions
  end

  # POST /kanbans/1/release
  # POST /kanbans/1/release.json
  # 发布看板卡
  def release
    redirect_to @kanban, notice: 'State Error.' and return unless KanbanState.switch_to(@kanban.state, KanbanState::RELEASED)
    @kanban.without_versioning do
      if @kanban.update(state: KanbanState::RELEASED)
        redirect_to @kanban, notice: 'Kanban was successfully released.'
      else
        redirect_to @kanban, notice: 'Kanban was failed released.'
      end
    end
  end

  # POST /kanbans/1/lock
  # POST /kanbans/1/lock.json
  # 锁定看板卡
  def lock
    redirect_to @kanban, notice: 'State Error.' and return unless KanbanState.switch_to(@kanban.state, KanbanState::LOCKED)
    @kanban.without_versioning do
      if @kanban.update(state: KanbanState::LOCKED)
        redirect_to @kanban, notice: 'Kanban was successfully locked.'
      else
        redirect_to @kanban, notice: 'Kanban was failed locked.'
      end
    end
  end

  # DELETE /kanbans/1/discard
  # DELETE /kanbasn/1/discard.json
  # 销毁看板卡
  def discard
    redirect_to @kanban, notice: 'State Error.' and return unless KanbanState.switch_to(@kanban.state, KanbanState::DELETED)
    @kanban.without_versioning do
      if @kanban.update(state: KanbanState::DELETED)
        redirect_to @kanban, notice: 'Kanban was successfully discarded.'
      else
        redirect_to @kanban, notice: 'Kanban was failed discarded.'
      end
    end
  end

  # GET /kanbans/search.json
  # Search by part_nr and product_nr
=begin
  def search
    msg = Message.new
    @q = params[:q]

    @kanbans = Kanban.search_for(params[:q]).paginate(:page => params[:page])
    msg.result = true
    msg.content = @kanbans

    render :index
  end
=end

  # GET /kanbans/add_routing_template
  def add_routing_template
    # authorize(Kanban)
    case params[:type].to_i
      when KanbanType::WHITE
        render partial: 'add_auto_routing'
      when KanbanType::BLUE
        render partial: 'add_semi_auto_routing'
      else
        render partial: 'add_auto_routing'
    end
  end


  # GET/POST
  def import
    # authorize(Kanban)
    if request.post?
      msg = Message.new
      begin
        file=params[:files][0]
        fd = FileData.new(data: file, original_name: file.original_filename, path: $upload_data_file_path, path_name: "#{Time.now.strftime('%Y%m%H%M%S%L')}~#{file.original_filename}")
        fd.save
        msg = FileHandler::Excel::KanbanHandler.import(fd)
      rescue => e
        msg.content = e.message
      end
      render json: msg
    end
  end

  # GET/POST
  def import_update_quantity
    # authorize(Kanban)
    if request.post?
      msg = Message.new
      begin
        file=params[:files][0]
        fd = FileData.new(data: file, original_name: file.original_filename, path: $upload_data_file_path, path_name: "#{Time.now.strftime('%Y%m%H%M%S%L')}~#{file.original_filename}")
        fd.save
        msg = FileHandler::Excel::KanbanHandler.import_update_quantity(fd.full_path)
      rescue => e
        msg.content = e.message
      end
      render json: msg
    end
  end

  def import_update_base
    if request.post?
      msg = Message.new
      begin
        file=params[:files][0]
        fd = FileData.new(data: file, original_name: file.original_filename, path: $upload_data_file_path, path_name: "#{Time.now.strftime('%Y%m%H%M%S%L')}~#{file.original_filename}")
        fd.save
        file=FileHandler::Csv::File.new(user_agent: request.user_agent.downcase, file_path: fd.full_path, file_name: file.original_filename)
        msg = FileHandler::Csv::KanbanHandler.import_update(file)
      rescue => e
        msg.content = e.message
      end
      render json: msg
    end
  end

  # 导入看板卡进行投卡
  def import_to_scan
    @hide_sidebar = true
    # authorize(Kanban)
    if request.post?
      msg = Message.new
      begin
        file=params[:files][0]
        fd = FileData.new(data: file, original_name: file.original_filename, path: $upload_data_file_path, path_name: "#{Time.now.strftime('%Y%m%H%M%S%L')}~#{file.original_filename}")
        fd.save
        #file=FileHandler::Csv::File.new(user_agent: request.user_agent.downcase, file_path: fd.full_path, file_name: file.original_filename)
        msg = FileHandler::Excel::KanbanHandler.import_scan(fd.full_path)
      rescue => e
        msg.content = e.message
      end
      render json: msg
    end
  end

  def import_to_get_kanban_list
    # authorize(Kanban)
    if request.post?
      msg = Message.new
      # begin
      file=params[:files][0]
      fd = FileData.new(data: file, original_name: file.original_filename, path: $upload_data_file_path, path_name: "#{Time.now.strftime('%Y%m%H%M%S%L')}~#{file.original_filename}")
      fd.save
      file=FileHandler::Csv::File.new(user_agent: request.user_agent.downcase, file_path: fd.full_path, file_name: file.original_filename)
      msg = FileHandler::Csv::KanbanHandler.import_to_get_kanban_list(file)
      # rescue => e
      #   msg.content = e.message
      # end
      render json: msg
    end
  end

  # 扫描销卡
  def scan_finish
    @hide_sidebar = true
    # authorize(Kanban)
    if request.post?
      #parse code
      parsed_code = Kanban.parse_printed_2DCode(params[:code])
      render json: {result: false, content: "Input Error"} and return unless parsed_code

      @kanban = Kanban.find_by_id(parsed_code[:id])

      #check Kanban State
      render json: {result: false, content: "Kanban is not released"} and return unless @kanban.state == KanbanState::RELEASED

      #check version of Kanban
      render json: {result: false, content: "Kanban not fount for#{parsed_code.to_json}"} and return unless @kanban
      render json: {result: false, content: "Kanban version error.#{parsed_code[:version_nr]}"} and return unless (version = @kanban.versions.where(id: parsed_code[:version_nr]))

      #check product order items
      order_items = []
      if @kanban.ktype == KanbanType::WHITE
        unless ((order_items = @kanban.production_order_items.where(state: ProductionOrderItemState.wait_scan_states)).count == 1)
          render json: {result: false, content: "Kanban 未结束生产!"} and return
        end
      else
        #如果是蓝卡，直接诶销卡
        order_items = @kanban.production_order_items.where(state: ProductionOrderItemState.wait_scan_states)
      end

      render json: {result: false, content: "为找到生产订单！"} and return if order_items == 0

      ProductionOrderItem.transaction do
        begin
          order_items.each do |order_item|
            #TODO 移库
            #
            order_item.update({state: ProductionOrderItemState::SCANNED})
          end
        rescue => e
          puts e.backtrace
          render json: {result: false, content: e.message} and return
        end
      end
      render json: {result: true, content: ""}
    end
  end

  # GET
  def management
    # authorize(Kanban)
  end

  # POST /kanbans/scan.json
  # 扫描看板卡
  def scan
    #parse code
    parsed_code = Kanban.parse_printed_2DCode(params[:code])
    render json: {result: false, content: "输入错误"} and return unless parsed_code

    @kanban = Kanban.find_by_id(parsed_code[:id])
    # authorize(@kanban)

    #check Kanban State
    render json: {result: false, content: "看板未发布"} and return unless @kanban.state == KanbanState::RELEASED

    #check version of Kanban
    render json: {result: false, content: "看板未找到：#{parsed_code.to_json}"} and return unless @kanban
    render json: {result: false, content: '看板为兰卡，不可以投！'} and return if @kanban.ktype==KanbanType::BLUE
    render json: {result: false, content: "看板版本错误#{parsed_code[:version_nr]}"} and return unless (version = @kanban.versions.where(id: parsed_code[:version_nr]))
    #last_version = @kanban.versions.last
    #need_update = last_version.created_at > version.created_at
    need_update = @kanban.versions.count > parsed_code[:version_nr].to_i

    #response dependent on Kanban type
    render json: {result: false, content: "看板已经更新，请重新打印!"} and return if need_update && @kanban.ktype == KanbanType::BLUE

    #check kanban quantity and bundle
    render json: {result: false, content: "看板数量为0，不能扫描！"} and return if @kanban.quantity == 0

    #2015-3-10 李其
    #不做扫描之后验证是否已经扫入，由工作人员控制
    #注释了这段代码，暂时不实现标注唯一的一张纸质看板卡
    if ProductionOrderItem.where("kanban_id = ? AND state= ?", @kanban.id, ProductionOrderItemState::INIT).count > 0
      render json: {result: false, content: "卡已投过，不可重复投卡"} and return
    end

    unless (@order = ProductionOrderItem.create(kanban_id: @kanban.id, code: params[:code]))
      render json: {result: false, content: "Production Order Item Created Failed"} and return
    end

    if need_update && @kanban.type == KanbanType::WHITE
      render json: {result: true, content: @order}
    else
      render json: {result: true, contnet: @order}
    end
  end

  # GET /kanbans/panel
  # GET /kanbans/panel.json
  def panel
    @hide_sidebar= true
    # authorize(Kanban)
  end


  def export_white
    msg = FileHandler::Excel::KanbanHandler.export_white
    if msg.result
      send_file msg.content
    else
      render json: msg
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_kanban
    @kanban = Kanban.find(params[:id])
    # authorize(@kanban)
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def kanban_params
    #params[:kanban]
    params.require(:kanban).permit(:id, :state, :remark, :quantity, :bundle,
                                   :safety_stock, :des_warehouse,
                                   :des_storage, :print_time, :part_id,
                                   :version, :ktype, :copies, :product_id
    )
  end
end

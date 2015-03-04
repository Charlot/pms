class KanbansController < ApplicationController
  before_action :set_kanban, only: [:show, :edit, :update, :destroy, :process_entities,
                                    :create_process_entities,:destroy_process_entities,
                                    :finish_production,:history,:release,:lock,:discard,:manage]

  # GET /kanbans
  # GET /kanbans.json
  def index
    @kanbans = Kanban.all
  end

  # GET /kanbans/1
  # GET /kanbans/1.json
  def show
  end

  # GET /kanbans/new
  def new
    @kanban = Kanban.new
    #1.times { @kanban.kanban_process_entities.build }
  end

  # GET /kanbans/1/edit
  def edit
  end

  # POST /kanbans
  # POST /kanbans.json
  def create
    @kanban = Kanban.new(kanban_params)

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

  # PATCH/PUT /kanbans/1
  # PATCH/PUT /kanbans/1.json
  def update
    respond_to do |format|
      if @kanban.update(kanban_params)
        format.html { redirect_to @kanban, notice: 'Kanban was successfully updated.' }
        format.json { render :show, status: :ok, location: @kanban }
      else
        format.html { render :edit }
        format.json { render json: @kanban.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /kanbans/1
  # DELETE /kanbans/1.json
  def destroy
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
    end_product = {part_id: @kanban.part_id,quantity:@kanban.quantity}
    raw_materials = []
    @kanban.get_raw_materials.each {|raw_material|
      raw_materials << {part_id: raw_material.part_id,quantity: raw_material.quantity * @kanban.quantity}
    }
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
  def release
    #TODO Release kanban
    redirect_to @kanban, notice: 'State Error.' and return unless KanbanState.switch_to(@kanban.state,KanbanState::RELEASED)

    if @kanban.update(state: KanbanState::RELEASED)
      redirect_to @kanban, notice: 'Kanban was successfully released.'
    else
       redirect_to @kanban, notice: 'Kanban was failed released.'
    end
  end

  # POST /kanbans/1/lock
  # POST /kanbans/1/lock.json
  def lock
    #TODO Lock kanban
    redirect_to @kanban, notice: 'State Error.' and return unless KanbanState.switch_to(@kanban.state,KanbanState::LOCKED)

    if @kanban.update(state: KanbanState::LOCKED)
      redirect_to @kanban, notice: 'Kanban was successfully locked.'
    else
      redirect_to @kanban, notice: 'Kanban was failed locked.'
    end
  end

  # DELETE /kanbans/1/discard
  # DELETE /kanbasn/1/discard.json
  def discard
    #TODO Delete kanban
    redirect_to @kanban, notice: 'State Error.' and return unless KanbanState.switch_to(@kanban.state,KanbanState::DELETED)

    if @kanban.update(state: KanbanState::DELETED)
      redirect_to @kanban, notice: 'Kanban was successfully discarded.'
    else
      redirect_to @kanban, notice: 'Kanban was failed discarded.'
    end
  end

  # GET /kanbans/search.json
  def search
    @kanban = Kanban.send("find_by_"+params[:attr],params[:val])
    respond_to do |format|
      format.json { render json: {result: false, content: "Not Found!"}} unless @kanban
      format.json { render json: {result: true, content: @kanban}}
    end
  end

  # GET /kanbans/add_routing_template
  def add_routing_template
    case params[:type].to_i
    when KanbanType::WHITE
      render partial:'add_auto_routing'
    when KanbanType::BLUE
      render partial:'add_semi_auto_routing'
    else
      render partial:'add_auto_routing'
    end
  end

  # POST /kanbans/scan.json
  def scan
    respond_to do |format|
      #parse code
      parsed_code = Kanban.parse_printed_2DCode(params[:code])
      format.json { render json: { result: false, content: "Input Error" }} unless parsed_code

      @kanban = Kanban.find_by_id(parsed_code[:id])

      #check Kanban State
      format.json { render json: { result: false, content: "Kanban is not released" }} unless @kanban.state == KanbanState::RELEASED

      #check version of Kanban
      format.json { render json: { result: false, content: "Kanban not fount for#{parsed_code.to_json}" }} unless @kanban
      format.json { render json: { result: false, content: "Kanban version error.#{parsed_code[:version_nr]}" }} unless (version =  @kanban.versions.where(id:parsed_code[version_nr]))
      last_version = @kanban.versions.last
      need_update = last_version.created_at > version.created_at

      #response dependent on Kanban type
      format.json { render json: { result: false, content: "Kanban has been updated,please reprint!" }} if need_update && @kanban.type == KanbanType::BLUE

      #reposne if has producing order
      #TODO

      #加入到待优化队列
      #TODO

      if need_update && @kanban.type == KanbanType::WHITE
        format.json { render json: { result:true, content: "Kanban Scaned,Causing! This Kanban was updated!" }}
      end
      format.json { render json: { result: true, contnet: "Kanban Scaned!"}}
    end
  end

  # GET /kanbans/1/manage
  # GET /kanbans/1/manage.json
  def manage
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_kanban
      @kanban = Kanban.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def kanban_params
      #params[:kanban]
      params.require(:kanban).permit(:id,:nr,:state,:remark,:quantity,
                                     :safety_stock,:source_warehouse,
                                     :source_storage,:des_warehouse,
                                     :des_storage,:print_time,:part_id,
                                     :version,:ktype,:copies,
                                     :product_id,kanban_process_entities_attributes:[:kanban_id,:process_entity_id]
      )
    end
end

class KanbansController < ApplicationController
  before_action :set_kanban, only: [:show, :edit, :update, :destroy, :process_entities,:create_process_entities,:destroy_process_entities,:finish_production]

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

  # GET /kanbans/1/process_entities
  # GET /kanbans/1/process_entities.json
  def process_entities

  end

  # POST /kanbans/1/create_process_entities
  # POST /kanbans/1/create_process_entities.json
  def create_process_entities
    msg = Message.new
    process_entity = ProcessEntity.find_by_nr(params[:process_entity_nr])
    if process_entity.nil?
      msg.content = 'Process Entity Not Found!'
    elsif (kanban_process_entity = @kanban.kanban_process_entities.build({process_entity_id:process_entity.id})).nil?
      msg.content = 'Created Failed'
    elsif kanban_process_entity.save
      msg.result = true
      msg.content = {id:kanban_process_entity.id,nr:kanban_process_entity.process_entity.nr}
    else
      msg.content = kanban_process_entity.errors.full_messages
    end
    render :json => msg
  end

  # DELETE /kanbans/1/destroy_process_entities
  # DELETE /kanbans/1/destroy_process_entities.json
  def destroy_process_entities
    msg = Message.new
    @kanban_process_entity = KanbanProcessEntity.find_by_id(params[:kanban_process_entity_id])
    if @kanban_process_entity.nil?
      msg.content = 'Kanban Process Entity Not Found!'
    elsif @kanban_process_entity.destroy
      msg.result = true
    else
      msg.content = @kanban_process_entity.errors.full_messages
    end
    render :json => msg
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
    render :json => msg
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_kanban
      @kanban = Kanban.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def kanban_params
      #params[:kanban]
      params.require(:kanban).permit(:id,:nr,:state,:remark,:quantity,:safety_stock,:source_warehouse,:source_storage,:des_warehouse,:des_storage,:print_time,:part_id,:version,:ktype)
    end
end

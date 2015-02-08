class ProcessEntitiesController < ApplicationController
  before_action :set_process_entity, only: [:show, :edit, :update, :destroy]

  # GET /process_entities
  # GET /process_entities.json
  def index
    @process_entities = ProcessEntity.all
  end

  # GET /process_entities/1
  # GET /process_entities/1.json
  def show
  end

  # GET /process_entities/new
  def new
    @process_entity = ProcessEntity.new
  end

  # GET /process_entities/1/edit
  def edit
  end

  # POST /process_entities
  # POST /process_entities.json
  def create
    params.permit!
    ProcessEntity.transaction do
      puts '*****'
      puts params[:process_entity]
      puts params[:custom_field]
      # puts permit_params[:process_entity].except(:custom_field)
      puts '*****'
      @process_entity = ProcessEntity.new(params[:process_entity])
      @process_entity.process_template=ProcessTemplate.find_by_id(params[:process_entity][:process_template_id])
      respond_to do |format|
        if @process_entity.save
          unless params[:custom_field].blank?
            params[:custom_field].each do |k, v|
              puts "#{k}:#{v}"
              if cf=CustomField.find_by_id(k)
                @process_entity.custom_values<<CustomValue.new(custom_field_id: k, value: cf.get_field_format_value(v))
              end
            end
          end
          format.html { redirect_to @process_entity, notice: 'Process entity was successfully created.' }
          format.json { render :show, status: :created, location: @process_entity }
        else
          format.html { render :new }
          format.json { render json: @process_entity.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # PATCH/PUT /process_entities/1
  # PATCH/PUT /process_entities/1.json
  def update
    respond_to do |format|
      if @process_entity.update(process_entity_params)
        format.html { redirect_to @process_entity, notice: 'Process entity was successfully updated.' }
        format.json { render :show, status: :ok, location: @process_entity }
      else
        format.html { render :edit }
        format.json { render json: @process_entity.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /process_entities/1
  # DELETE /process_entities/1.json
  def destroy
    @process_entity.destroy
    respond_to do |format|
      format.html { redirect_to process_entities_url, notice: 'Process entity was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_process_entity
    @process_entity = ProcessEntity.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def process_entity_params
    params.require(:process_entity).permit(:nr, :name, :description, :stand_time, :process_template_id, :workstation_type_id, :cost_center_id)
  end
end

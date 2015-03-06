class PartsController < ApplicationController
  before_action :set_part, only: [:show, :edit, :update, :destroy,
                         :add_process_entities,:delete_process_entities]

  # GET /parts
  # GET /parts.json
  def index
    @parts = Part.all
  end

  # GET /parts/1
  # GET /parts/1.json
  def show
  end

  # GET /parts/new
  def new
    @part = Part.new
  end

  # GET /parts/1/edit
  def edit
  end

  # POST /parts
  # POST /parts.json
  def create
    @part = Part.new(part_params)

    respond_to do |format|
      if @part.save
        format.html { redirect_to @part, notice: 'Part was successfully created.' }
        format.json { render :show, status: :created, location: @part }
      else
        format.html { render :new }
        format.json { render json: @part.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /parts/1
  # PATCH/PUT /parts/1.json
  def update
    respond_to do |format|
      if @part.update(part_params)
        format.html { redirect_to @part, notice: 'Part was successfully updated.' }
        format.json { render :show, status: :ok, location: @part }
      else
        format.html { render :edit }
        format.json { render json: @part.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /parts/1
  # DELETE /parts/1.json
  def destroy
    @part.destroy
    respond_to do |format|
      format.html { redirect_to parts_url, notice: 'Part was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  # GET /parts/search
  # GET /parts/search.json
  def search
    @part = Part.send("find_by_"+params[:attr],params[:val])
    respond_to do |format|
      format.json { render json: {result: false, content: "Not Found!"}} unless @part
      format.json { render json: {result: true, content: @part.as_json(include: :process_entities)}}
    end
  end

  # POST /parts/1/add_process_entitties
  def add_process_entities
    params[:process_entities].each {|pe_id|
      @part.part_process_entities<<PartProcessEntity.create(process_entity_id:pe_id)
    }

    if @part.save
      render json: {result:true,content:{}}
    else
      render json: {result:false,content:{}}
    end
  end

  # DELETE /parts/1/delete_process_entities
  def delete_process_entities
    msg = Message.new
    msg.result = true
    ActiveRecord::Base.transaction do
      begin
        @part.part_process_entities.where(process_entity_id:params[:process_entities]).each{|x|x.destroy}
      rescue
        msg.result = false
      end
    end

    render json: msg
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_part
      @part = Part.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def part_params
      params.require(:part).permit(:nr, :custom_nr, :type, :strip_length, :resource_group_id, :measure_unit_id)
    end
end

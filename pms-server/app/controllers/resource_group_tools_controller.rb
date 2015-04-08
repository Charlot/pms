class ResourceGroupToolsController < ApplicationController
  before_action :set_resource_group_tool, only: [:show, :edit, :update, :destroy]

  # GET /resource_group_tools
  # GET /resource_group_tools.json
  def index
    @resource_group_tools = ResourceGroupTool.all
  end

  # GET /resource_group_tools/1
  # GET /resource_group_tools/1.json
  def show
  end

  # GET /resource_group_tools/new
  def new
    @resource_group_tool = ResourceGroupTool.new
  end

  # GET /resource_group_tools/1/edit
  def edit
  end

  # POST /resource_group_tools
  # POST /resource_group_tools.json
  def create
    @resource_group_tool = ResourceGroupTool.new(resource_group_tool_params.except(:resource_group_part))
    unless resource_group_tool_params[:resource_group_part].blank?
      @resource_group_part=@resource_group_tool.build_resource_group_part
      @resource_group_part.part=Part.find_by_nr(resource_group_tool_params[:resource_group_part])
    end

    respond_to do |format|
      if @resource_group_tool.save
        format.html { redirect_to @resource_group_tool, notice: 'Resource group tool was successfully created.' }
        format.json { render :show, status: :created, location: @resource_group_tool }
      else
        format.html { render :new }
        format.json { render json: @resource_group_tool.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /resource_group_tools/1
  # PATCH/PUT /resource_group_tools/1.json
  def update
    respond_to do |format|
      if @resource_group_tool.update(resource_group_tool_params.except(:resource_group_part))
        unless resource_group_tool_params[:resource_group_part].blank?
          @resource_group_part=@resource_group_tool.resource_group_part
          @resource_group_part.part=Part.find_by_nr(resource_group_tool_params[:resource_group_part])
          @resource_group_part.save
        end
        format.html { redirect_to @resource_group_tool, notice: 'Resource group tool was successfully updated.' }
        format.json { render :show, status: :ok, location: @resource_group_tool }
      else
        format.html { render :edit }
        format.json { render json: @resource_group_tool.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /resource_group_tools/1
  # DELETE /resource_group_tools/1.json
  def destroy
    @resource_group_tool.destroy
    respond_to do |format|
      format.html { redirect_to resource_group_tools_url, notice: 'Resource group tool was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_resource_group_tool
    @resource_group_tool = ResourceGroupTool.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def resource_group_tool_params
    # params[:resource_group_tool][:resource_group_part]=Part.find_by_nr(params[:resource_group_tool][:resource_group_part])
    params.require(:resource_group_tool).permit(:nr, :type, :name, :description, :resource_group_part)
  end
end

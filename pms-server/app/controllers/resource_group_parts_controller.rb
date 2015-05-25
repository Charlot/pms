class ResourceGroupPartsController < ApplicationController
  before_action :set_resource_group_part, only: [:edit, :destroy]
  before_action :set_resource_group_tool, only: [:index, :new]
  before_action :set_resource_group_parts, only: [:index]
  before_action :prepare_resource_group_part_params, only: [:create]

  # GET /resource_group_parts
  # GET /resource_group_parts.json
  def index
    @resource_group_part = ResourceGroupPart.new
  end

  # GET /resource_group_parts/1
  # GET /resource_group_parts/1.json
  def show
  end

  def group_by_part
 #   authorize(ResourceGroupPart)
    @msg=Message.new
    if (part=Part.find_by_nr(params[:part])) && (rp=part.resource_group_part)
      @msg.content=rp.resource_group_tool
      @msg.result=true
    end
    render json: @msg
  end

  # GET /resource_group_parts/new
  def new
    @resource_group_part = ResourceGroupPart.new
  #  authorize(@resource_group_part)
  end

  # GET /resource_group_parts/1/edit
  def edit
  end

  # POST /resource_group_parts
  # POST /resource_group_parts.json
  def create
 #   authorize(ResourceGroupPart)
    respond_to do |format|
      if @resource_group_part.errors.blank? && @resource_group_part.save
        flash.clear
        format.html { redirect_to resource_group_tool_resource_group_parts_path(@resource_group_tool), notice: 'Resource group part was successfully created.' }
        format.json { render :show, status: :created, location: @resource_group_part }
      else
        # format.html { render :new }
        format.html { redirect_to resource_group_tool_resource_group_parts_path(@resource_group_tool), notice: @resource_group_part.errors.to_json }
        format.json { render json: @resource_group_part.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /resource_group_parts/1
  # PATCH/PUT /resource_group_parts/1.json
  # def update
  #   respond_to do |format|
  #     if @resource_group_part.errors.blank? && @resource_group_part.save
  #       flash.clear
  #       format.html { redirect_to resource_group_tool_resource_group_parts_path(@resource_group_tool), notice: 'Resource group part was successfully updated.' }
  #       format.json { render :show, status: :ok, location: @resource_group_part }
  #     else
  #       # format.html { render :edit }
  #       format.html { redirect_to resource_group_tool_resource_group_parts_path(@resource_group_tool), notice: @resource_group_part.errors.to_json }
  #       format.json { render json: @resource_group_part.errors, status: :unprocessable_entity }
  #     end
  #   end
  # end

  # DELETE /resource_group_parts/1
  # DELETE /resource_group_parts/1.json
  def destroy
    @resource_group_part.destroy
    respond_to do |format|
      format.html { redirect_to resource_group_tool_resource_group_parts_path(@resource_group_part.resource_group_tool), notice: 'Resource group part was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
  def set_resource_group_tool
    unless (@resource_group_tool=ResourceGroupTool.find_by_id(params[:resource_group_tool_id]))
      redirect_to resource_group_tools_path, notice: 'Please select a ResourceGroupTool'
    end
    # authorize(@resource_group_tool)
  end

  def set_resource_group_parts
    @resource_group_parts = ResourceGroupTool.find_by_id(params[:resource_group_tool_id]).resource_group_parts
    # authorize(@resource_group_parts)
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_resource_group_part
    @resource_group_part = ResourceGroupPart.find(params[:id])
  #  authorize(@resource_group_part)
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def resource_group_part_params
    params.require(:resource_group_part).permit(:part_id, :resource_group_id)
  end

  def prepare_resource_group_part_params
    mp=resource_group_part_params

    @resource_group_tool=ResourceGroupTool.find_by_id(params[:resource_group_part][:resource_group_id])
    if action_name=='create'
      @resource_group_part = ResourceGroupPart.new(mp) if action_name=='create'

      mp.keys.each { |k|
        flash[k]=mp[k]
      }
    end

    if part=Part.find_by_nr(mp[:part_id])
      if part.resource_group_tool.nil?
        unless @resource_group_tool.resource_group_parts.where(part_id: part.id).first
          @resource_group_part.part=part
        else
          @resource_group_part.errors.add(:part, "part #{mp[:part_id]}, has been added")
        end
      else
        @resource_group_part.errors.add(:part, "part #{mp[:part_id]}, has been add to group #{part.resource_group_tool.nr}")
      end
    else
      @resource_group_part.errors.add(:part, "part #{mp[:part_id]}, not exists")
    end
  end
end

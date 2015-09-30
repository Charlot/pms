class PartToolsController < ApplicationController
  before_action :set_part_tool, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @part_tools = PartTool.all
    respond_with(@part_tools)
  end

  def show
    respond_with(@part_tool)
  end

  def new
    @part_tool = PartTool.new
    respond_with(@part_tool)
  end

  def edit
  end

  def create
    @part_tool = PartTool.new(part_tool_params)
    @part_tool.save
    respond_with(@part_tool)
  end

  def update
    @part_tool.update(part_tool_params)
    respond_with(@part_tool)
  end

  def destroy
    @tool=@part_tool.tool
    @part_tool.destroy
    respond_with(@tool)
  end

  private
  def set_part_tool
    @part_tool = PartTool.find(params[:id])
  end

  def part_tool_params
    params.require(:part_tool).permit(:part_id, :tool_id)
  end
end

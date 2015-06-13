class ToolsController < ApplicationController
  before_action :set_tool, only: [:show, :edit, :update, :destroy]

  # GET /tools
  # GET /tools.json
  def index
    @tools = Tool.paginate(:page => params[:page])
  end

  # GET /tools/1
  # GET /tools/1.json
  def show
  end

  # GET /tools/new
  def new
    @tool = Tool.new
    # authorize(@tool)
  end

  # GET /tools/1/edit
  def edit
  end

  # POST /tools
  # POST /tools.json
  def create
    @tool = Tool.new(tool_params.except(:part))
    # authorize(@tool)
    unless tool_params[:part].blank?
      if part= Part.find_by_nr(tool_params[:part])
        @tool.part=part
        @tool.resource_group_tool=part.resource_group_tool
      end
    end

    respond_to do |format|
      if @tool.save
        format.html { redirect_to @tool, notice: 'Tool was successfully created.' }
        format.json { render :show, status: :created, location: @tool }
      else
        format.html { render :new }
        format.json { render json: @tool.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tools/1
  # PATCH/PUT /tools/1.json
  def update
    unless tool_params[:part].blank?
      if part= Part.find_by_nr(tool_params[:part])
        @tool.part=part
        @tool.resource_group_tool=part.resource_group_tool
      end
    end

    respond_to do |format|
      if @tool.update(tool_params.except(:part))
        format.html { redirect_to @tool, notice: 'Tool was successfully updated.' }
        format.json { render :show, status: :ok, location: @tool }
      else
        format.html { render :edit }
        format.json { render json: @tool.errors, status: :unprocessable_entity }
      end
    end
  end

  def import
    # authorize(Tool)
    if request.post?
      msg = Message.new
      begin
        file=params[:files][0]
        fd = FileData.new(data: file, original_name: file.original_filename, path: $upload_data_file_path, path_name: "#{Time.now.strftime('%Y%m%d%H%M%S%L')}~#{file.original_filename}")
        fd.save
        file=FileHandler::Csv::File.new(user_agent: request.user_agent.downcase, file_path: fd.full_path, file_name: file.original_filename)
        msg = FileHandler::Csv::ToolHandler.import(file)
      rescue => e
        msg.content = e.message
      end
      render json: msg
    end
  end

  # DELETE /tools/1
  # DELETE /tools/1.json
  def destroy
    @tool.destroy
    respond_to do |format|
      format.html { redirect_to tools_url, notice: 'Tool was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_tool
    @tool = Tool.find(params[:id])
    # authorize(@tool)
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def tool_params
    params.require(:tool).permit(:nr, :part, :part_id, :mnt, :used_days, :rql, :tol, :rql_date)
  end
end

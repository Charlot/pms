class PartBomsController < ApplicationController
  before_action :set_part_bom, only: [:edit, :update, :destroy]

  # GET /part_boms
  # GET /part_boms.json
  def index
    @part_boms = PartBom.all
  end

  # GET /part_boms/1
  # GET /part_boms/1.json
  def show
    @bom=PartBom.detail_by_part_id(params[:id])
  end

  def search
    if @part=Part.find_by_nr(params[:part_nr])
      @bom=PartBom.detail_by_part(@part)
    end
    @part_nr=params[:part_nr]
  end

  def import
    if request.post?
      msg=Message.new
      begin
        file=params[:files][0]
        fd=FileData.new(data: file, original_name: file.original_filename, path: $upload_data_file_path, path_name: "#{Time.now.strftime('%Y%m%d%H%M%S%L')}-#{file.original_filename}")
        fd.save
        file=FileHandler::Csv::File.new(user_agent: request.user_agent.downcase, file_path: fd.full_path, file_name: file.original_filename)
        msg=FileHandler::Csv::Bom.import(file)
      rescue => e
        msg.content = e.message
      end
      render json: msg
    end
  end

  # GET /part_boms/new
  def new
    @part_bom = PartBom.new
  end

  # GET /part_boms/1/edit
  def edit
  end

  # POST /part_boms
  # POST /part_boms.json
  def create
    @part_bom = PartBom.new(part_bom_params)

    respond_to do |format|
      if @part_bom.save
        format.html { redirect_to @part_bom, notice: 'Part bom was successfully created.' }
        format.json { render :show, status: :created, location: @part_bom }
      else
        format.html { render :new }
        format.json { render json: @part_bom.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /part_boms/1
  # PATCH/PUT /part_boms/1.json
  def update
    respond_to do |format|
      if @part_bom.update(part_bom_params)
        format.html { redirect_to @part_bom, notice: 'Part bom was successfully updated.' }
        format.json { render :show, status: :ok, location: @part_bom }
      else
        format.html { render :edit }
        format.json { render json: @part_bom.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /part_boms/1
  # DELETE /part_boms/1.json
  def destroy
    @part_bom.destroy
    respond_to do |format|
      format.html { redirect_to part_boms_url, notice: 'Part bom was successfully destroyed.' }
      format.json { head :no_content }
    end
  end


  private
  # Use callbacks to share common setup or constraints between actions.
  def set_part_bom
    @part_bom = PartBom.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def part_bom_params
    params.require(:part_bom).permit(:part_id, :bom_item_id, :quantity)
  end
end

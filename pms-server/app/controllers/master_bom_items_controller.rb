class MasterBomItemsController < ApplicationController
  before_action :set_master_bom_item, only: [:show, :edit, :update, :destroy]

  # GET /master_bom_items
  # GET /master_bom_items.json
  def index
    @master_bom_items = MasterBomItem.search(params).paginate(:page => params[:page])
  end

  # GET /master_bom_items/1
  # GET /master_bom_items/1.json
  def show
  end

  # GET /master_bom_items/new
  def new
    @master_bom_item = MasterBomItem.new
    # authorize(@master_bom_item)
  end

  # GET /master_bom_items/1/edit
  def edit
  end

  # POST /master_bom_items
  # POST /master_bom_items.json
  def create
    @master_bom_item = MasterBomItem.new(master_bom_item_params)
    # authorize(@master_bom_item)

    respond_to do |format|
      if @master_bom_item.save
        format.html { redirect_to @master_bom_item, notice: 'Master bom item was successfully created.' }
        format.json { render :show, status: :created, location: @master_bom_item }
      else
        format.html { render :new }
        format.json { render json: @master_bom_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /master_bom_items/1
  # PATCH/PUT /master_bom_items/1.json
  def update
    respond_to do |format|
      if @master_bom_item.update(master_bom_item_params)
        format.html { redirect_to @master_bom_item, notice: 'Master bom item was successfully updated.' }
        format.json { render :show, status: :ok, location: @master_bom_item }
      else
        format.html { render :edit }
        format.json { render json: @master_bom_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /master_bom_items/1
  # DELETE /master_bom_items/1.json
  def destroy
    @master_bom_item.destroy
    respond_to do |format|
      format.html { redirect_to master_bom_items_url, notice: 'Master bom item was successfully destroyed.' }
      format.json { head :no_content }
    end
  end


  def import
    # authorize(MachineTimeRule)
    if request.post?
      msg = Message.new
      begin
        file=params[:files][0]
        fd = FileData.new(data: file, original_name: file.original_filename, path: $upload_data_file_path, path_name: "#{Time.now.strftime('%Y%m%H%M%S%L')}~#{file.original_filename}")
        fd.save
        msg = FileHandler::Excel::MasterBomItemHandler.import(fd)
      rescue => e
        msg.content = e.message
      end
      render json: msg
    end

    # # authorize(MasterBomItem)
    # if request.post?
    #   msg = Message.new
    #   begin
    #     file=params[:files][0]
    #     fd = FileData.new(data: file, original_name: file.original_filename, path: $upload_data_file_path, path_name: "#{Time.now.strftime('%Y%m%H%M%S%L')}~#{file.original_filename}")
    #     fd.save
    #     file=FileHandler::Csv::File.new(user_agent: request.user_agent.downcase, file_path: fd.full_path, file_name: file.original_filename)
    #     msg = FileHandler::Csv::MasterBomItemHandler.import(file)
    #   rescue => e
    #     msg.content = e.message
    #   end
    #   render json: msg
    # end
  end

  def transport
    # authorize(MasterBomItem)
    if request.post?
      msg = Message.new
      begin
        file=params[:files][0]
        fd = FileData.new(data: file, original_name: file.original_filename, path: $upload_data_file_path, path_name: "#{Time.now.strftime('%Y%m%H%M%S%L')}~#{file.original_filename}")
        fd.save
        file=FileHandler::Csv::File.new(user_agent: request.user_agent.downcase, file_path: fd.full_path, file_name: file.original_filename)
        msg = FileHandler::Csv::MasterBomItemHandler.transport(file)
      rescue => e
        msg.content = e.message
      end
      render json: msg
    end
  end


  def export
    msg = Message.new
    begin
      msg = FileHandler::Excel::MasterBomItemHandler.export(params)
    rescue => e
      msg.content = e.message
    end
    if msg.result
      send_file msg.content
    else
      render json: msg
    end
  end

  def search
    @master_bom_items=MasterBomItem.search(params).paginate(:page => params[:page])
    @product_nr=params[:product_nr]
    @bom_item_nr=params[:bom_item_nr]
    @department_id=params[:department_id]
    render :index
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_master_bom_item
    @master_bom_item = MasterBomItem.find(params[:id])
    # authorize(@master_bom_item)
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def master_bom_item_params
    params.require(:master_bom_item).permit(:qty, :bom_item_id, :product_id, :department_id)
  end
end

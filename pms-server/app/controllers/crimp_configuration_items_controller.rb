class CrimpConfigurationItemsController < ApplicationController
  before_action :set_crimp_configuration_item, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @crimp_configuration_items = CrimpConfigurationItem.all
    respond_with(@crimp_configuration_items)
  end

  def show
    respond_with(@crimp_configuration_item)
  end

  def new
    @crimp_configuration_item = CrimpConfigurationItem.new
    respond_with(@crimp_configuration_item)
  end

  def edit
  end

  def create
    @crimp_configuration_item = CrimpConfigurationItem.new(crimp_configuration_item_params)
    @crimp_configuration_item.save
    respond_with(@crimp_configuration_item)
  end

  def import
    if request.post?
      msg = Message.new
      begin
        file=params[:files][0]
        fd = FileData.new(data: file, original_name: file.original_filename, path: $upload_data_file_path, path_name: "#{Time.now.strftime('%Y%m%d%H%M%S%L')}~#{file.original_filename}")
        fd.save
        msg = FileHandler::Excel::CrimpConfigurationItemHandler.import(fd, session[:crimp_configuration_id])
      rescue => e
        msg.content = e.message
      end
      render json: msg
    end
  end

  def update
    @crimp_configuration_item.update(crimp_configuration_item_params)
    respond_with(@crimp_configuration_item)
  end

  def destroy
    @crimp_configuration_item.destroy
    respond_with(@crimp_configuration_item)
  end

  private
    def set_crimp_configuration_item
      @crimp_configuration_item = CrimpConfigurationItem.find(params[:id])
    end

    def crimp_configuration_item_params
      params.require(:crimp_configuration_item).permit(:crimp_configuration_id, :side, :min_pulloff, :crimp_height, :crimp_height_iso, :crimp_width, :crimp_width_iso, :i_crimp_height, :i_crimp_height_iso, :i_crimp_width, :i_crimp_width_iso)
    end
end

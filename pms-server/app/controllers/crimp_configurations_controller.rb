class CrimpConfigurationsController < ApplicationController
  before_action :set_crimp_configuration, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @crimp_configurations = CrimpConfiguration.paginate(:page=>params[:page], :per_page=>15)#all
    respond_with(@crimp_configurations)
  end

  def show
    respond_with(@crimp_configuration)
  end

  def new
    @crimp_configuration = CrimpConfiguration.new
    respond_with(@crimp_configuration)
  end

  def edit
  end

  def create
    @crimp_configuration = CrimpConfiguration.new(crimp_configuration_params)
    @crimp_configuration.save
    respond_with(@crimp_configuration)
  end

  def update
    respond_to do |format|
      if @crimp_configuration.update(crimp_configuration_params)
        format.html { redirect_to @crimp_configuration, notice: 'crimp configuration was successfully updated.' }
        format.json { render :show, status: :ok, location: @crimp_configuration }
      else
        format.html { render :edit }
        format.json { render json: @crimp_configuration.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @crimp_configuration.destroy
    respond_with(@crimp_configuration)
  end

  def import
    if request.post?
      msg = Message.new
      begin
        file=params[:files][0]
        fd = FileData.new(data: file, original_name: file.original_filename, path: $upload_data_file_path, path_name: "#{Time.now.strftime('%Y%m%d%H%M%S%L')}~#{file.original_filename}")
        fd.save
        msg = FileHandler::Excel::CrimpConfigurationHandler.import(fd)
      rescue => e
        msg.content = e.message
      end
      render json: msg
    end
  end

  private
    def set_crimp_configuration
      @crimp_configuration = CrimpConfiguration.find(params[:id])
    end

    def crimp_configuration_params
      params.require(:crimp_configuration).permit(:tool_id, :custom_id, :wire_group_name, :part_id, :wire_type, :cross_section, :min_pulloff_value, :crimp_height, :crimp_height_iso, :crimp_width, :crimp_width_iso, :i_crimp_height, :i_crimp_height_iso, :i_crimp_width, :i_crimp_width_iso)
    end
end
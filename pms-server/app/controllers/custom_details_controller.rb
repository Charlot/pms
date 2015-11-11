class CustomDetailsController < ApplicationController
  before_action :set_custom_detail, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @custom_details = CustomDetail.paginate(:page=>params[:page], :per_page=>15)#all
    respond_with(@custom_details)
  end

  def show
    respond_with(@custom_detail)
  end

  def new
    @custom_detail = CustomDetail.new
    respond_with(@custom_detail)
  end

  def edit
  end

  def create
    @custom_detail = CustomDetail.new(custom_detail_params)
    @custom_detail.save
    respond_with(@custom_detail)
  end

  def update
    @custom_detail.update(custom_detail_params)
    respond_with(@custom_detail)
  end

  def destroy
    @custom_detail.destroy
    respond_with(@custom_detail)
  end

  def import
    if request.post?
      msg = Message.new
      begin
        file=params[:files][0]
        fd = FileData.new(data: file, original_name: file.original_filename, path: $upload_data_file_path, path_name: "#{Time.now.strftime('%Y%m%d%H%M%S%L')}~#{file.original_filename}")
        fd.save
        msg = FileHandler::Excel::CustomDetailHandler.import(fd)
      rescue => e
        msg.content = e.message
      end
      render json: msg
    end
  end

  private
    def set_custom_detail
      @custom_detail = CustomDetail.find(params[:id])
    end

    def custom_detail_params
      params.require(:custom_detail).permit(:part_nr_from, :part_nr_to, :custom_nr)
    end
end

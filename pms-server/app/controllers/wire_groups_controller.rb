class WireGroupsController < ApplicationController
  before_action :set_wire_group, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @wire_groups = WireGroup.paginate(:page=>params[:page], :per_page=>15)#all
    respond_with(@wire_groups)
  end

  def show
    respond_with(@wire_group)
  end

  def new
    @wire_group = WireGroup.new
    respond_with(@wire_group)
  end

  def edit
  end

  def create
    @wire_group = WireGroup.new(wire_group_params)
    @wire_group.save
    respond_with(@wire_group)
  end

  def update
    @wire_group.update(wire_group_params)
    respond_with(@wire_group)
  end

  def destroy
    @wire_group.destroy
    respond_with(@wire_group)
  end

  def import
    if request.post?
      msg = Message.new
      begin
        file=params[:files][0]
        fd = FileData.new(data: file, original_name: file.original_filename, path: $upload_data_file_path, path_name: "#{Time.now.strftime('%Y%m%d%H%M%S%L')}~#{file.original_filename}")
        fd.save
        msg = FileHandler::Excel::WireGroupHandler.import(fd)
      rescue => e
        msg.content = e.message
      end
      render json: msg
    end
  end

  private
    def set_wire_group
      @wire_group = WireGroup.find(params[:id])
    end

    def wire_group_params
      params.require(:wire_group).permit(:group_name, :wire_type, :cross_section)
    end
end

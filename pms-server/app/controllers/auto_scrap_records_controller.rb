class AutoScrapRecordsController < ApplicationController
  before_action :set_auto_scrap_record, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @auto_scrap_records = AutoScrapRecord.all
    respond_with(@auto_scrap_records)
  end

  def show
    respond_with(@auto_scrap_record)
  end

  def new
    @auto_scrap_record = AutoScrapRecord.new
    respond_with(@auto_scrap_record)
  end

  def edit
  end

  def create
    @auto_scrap_record = AutoScrapRecord.new(auto_scrap_record_params)
    @auto_scrap_record.save
    respond_with(@auto_scrap_record)
  end

  def update
    @auto_scrap_record.update(auto_scrap_record_params)
    respond_with(@auto_scrap_record)
  end

  def destroy
    @auto_scrap_record.destroy
    respond_with(@auto_scrap_record)
  end

  private
    def set_auto_scrap_record
      @auto_scrap_record = AutoScrapRecord.find(params[:id])
    end

    def auto_scrap_record_params
      params.require(:auto_scrap_record).permit(:scrap_id, :order_nr, :kanban_nr, :machine_nr, :part_nr, :qty, :user_id)
    end
end

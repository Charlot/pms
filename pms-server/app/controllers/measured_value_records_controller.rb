class MeasuredValueRecordsController < ApplicationController
  before_action :set_measured_value_record, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @measured_value_records = MeasuredValueRecord.order(created_at: :desc).paginate(:page=>params[:page], :per_page=>15)#all
    respond_with(@measured_value_records)
  end

  def show
    respond_with(@measured_value_record)
  end

  def new
    @measured_value_record = MeasuredValueRecord.new
    respond_with(@measured_value_record)
  end

  def edit
  end

  def create
    @measured_value_record = MeasuredValueRecord.new(measured_value_record_params)
    @measured_value_record.save
    respond_with(@measured_value_record)
  end

  def update
    @measured_value_record.update(measured_value_record_params)
    respond_with(@measured_value_record)
  end

  def destroy
    @measured_value_record.destroy
    respond_with(@measured_value_record)
  end

  private
    def set_measured_value_record
      @measured_value_record = MeasuredValueRecord.find(params[:id])
    end

    def measured_value_record_params
      params.require(:measured_value_record).permit(:production_order_id, :part_id, :machine_id, :crimp_height_1, :crimp_height_2, :crimp_height_3, :crimp_height_4, :crimp_height_5, :crimp_width, :i_crimp_heigth, :i_crimp_width, :pulloff_value, :note)
    end
end

class NcrApiLogsController < ApplicationController
  before_action :set_ncr_api_log, only: [:show, :edit, :update, :destroy]

  # GET /ncr_api_logs
  # GET /ncr_api_logs.json
  def index
    @ncr_api_logs = NcrApiLog.all
  end

  # GET /ncr_api_logs/1
  # GET /ncr_api_logs/1.json
  def show
  end

  # GET /ncr_api_logs/new
  def new
    @ncr_api_log = NcrApiLog.new
    authorize(@ncr_api_log)
  end

  # GET /ncr_api_logs/1/edit
  def edit
  end

  # POST /ncr_api_logs
  # POST /ncr_api_logs.json
  def create
    @ncr_api_log = NcrApiLog.new(ncr_api_log_params)
    authorize(@ncr_api_log)
    respond_to do |format|
      if @ncr_api_log.save
        format.html { redirect_to @ncr_api_log, notice: 'Ncr api log was successfully created.' }
        format.json { render :show, status: :created, location: @ncr_api_log }
      else
        format.html { render :new }
        format.json { render json: @ncr_api_log.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /ncr_api_logs/1
  # PATCH/PUT /ncr_api_logs/1.json
  def update
    respond_to do |format|
      if @ncr_api_log.update(ncr_api_log_params)
        format.html { redirect_to @ncr_api_log, notice: 'Ncr api log was successfully updated.' }
        format.json { render :show, status: :ok, location: @ncr_api_log }
      else
        format.html { render :edit }
        format.json { render json: @ncr_api_log.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /ncr_api_logs/1
  # DELETE /ncr_api_logs/1.json
  def destroy
    @ncr_api_log.destroy
    respond_to do |format|
      format.html { redirect_to ncr_api_logs_url, notice: 'Ncr api log was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_ncr_api_log
      @ncr_api_log = NcrApiLog.find(params[:id])
      authorize(@ncr_api_log)
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def ncr_api_log_params
      params.require(:ncr_api_log).permit(:machine_nr, :order_item_nr, :log_type, :order_item_state, :order_item_qty, :params_detail, :return_detail)
    end
end

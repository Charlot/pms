class ProcessCustomValuesController < ApplicationController
  before_action :set_process_custom_value, only: [:show, :edit, :update, :destroy]

  # GET /process_custom_values
  # GET /process_custom_values.json
  def index
    @process_custom_values = ProcessCustomValue.all
  end

  # GET /process_custom_values/1
  # GET /process_custom_values/1.json
  def show
  end

  # GET /process_custom_values/new
  def new
    @process_custom_value = ProcessCustomValue.new
  end

  # GET /process_custom_values/1/edit
  def edit
  end

  # POST /process_custom_values
  # POST /process_custom_values.json
  def create
    @process_custom_value = ProcessCustomValue.new(process_custom_value_params)

    respond_to do |format|
      if @process_custom_value.save
        format.html { redirect_to @process_custom_value, notice: 'Process custom value was successfully created.' }
        format.json { render :show, status: :created, location: @process_custom_value }
      else
        format.html { render :new }
        format.json { render json: @process_custom_value.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /process_custom_values/1
  # PATCH/PUT /process_custom_values/1.json
  def update
    respond_to do |format|
      if @process_custom_value.update(process_custom_value_params)
        format.html { redirect_to @process_custom_value, notice: 'Process custom value was successfully updated.' }
        format.json { render :show, status: :ok, location: @process_custom_value }
      else
        format.html { render :edit }
        format.json { render json: @process_custom_value.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /process_custom_values/1
  # DELETE /process_custom_values/1.json
  def destroy
    @process_custom_value.destroy
    respond_to do |format|
      format.html { redirect_to process_custom_values_url, notice: 'Process custom value was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_process_custom_value
      @process_custom_value = ProcessCustomValue.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def process_custom_value_params
      params.require(:process_custom_value).permit(:customized_type, :customized_id, :custom_field_id, :value)
    end
end

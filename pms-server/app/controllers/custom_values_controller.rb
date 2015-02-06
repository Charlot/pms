class CustomValuesController < ApplicationController
  before_action :set_custom_value, only: [:show, :edit, :update, :destroy]

  # GET /custom_values
  # GET /custom_values.json
  def index
    @custom_values = CustomValue.all
  end

  # GET /custom_values/1
  # GET /custom_values/1.json
  def show
  end

  # GET /custom_values/new
  def new
    @custom_value = CustomValue.new
  end

  # GET /custom_values/1/edit
  def edit
  end

  # POST /custom_values
  # POST /custom_values.json
  def create
    @custom_value = CustomValue.new(custom_value_params)

    respond_to do |format|
      if @custom_value.save
        format.html { redirect_to @custom_value, notice: 'Custom value was successfully created.' }
        format.json { render :show, status: :created, location: @custom_value }
      else
        format.html { render :new }
        format.json { render json: @custom_value.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /custom_values/1
  # PATCH/PUT /custom_values/1.json
  def update
    respond_to do |format|
      if @custom_value.update(custom_value_params)
        format.html { redirect_to @custom_value, notice: 'Custom value was successfully updated.' }
        format.json { render :show, status: :ok, location: @custom_value }
      else
        format.html { render :edit }
        format.json { render json: @custom_value.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /custom_values/1
  # DELETE /custom_values/1.json
  def destroy
    @custom_value.destroy
    respond_to do |format|
      format.html { redirect_to custom_values_url, notice: 'Custom value was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_custom_value
      @custom_value = CustomValue.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def custom_value_params
      params.require(:custom_value).permit(:customized_type, :customized_id, :custom_field_id, :value)
    end
end

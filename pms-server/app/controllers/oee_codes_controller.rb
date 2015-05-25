class OeeCodesController < ApplicationController
  before_action :set_oee_code, only: [:show, :edit, :update, :destroy]

  # GET /oee_codes
  # GET /oee_codes.json
  def index
    @oee_codes = OeeCode.all
  end

  # GET /oee_codes/1
  # GET /oee_codes/1.json
  def show
  end

  # GET /oee_codes/new
  def new
    @oee_code = OeeCode.new
    # authorize(@oee_code)
  end

  # GET /oee_codes/1/edit
  def edit
  end

  # POST /oee_codes
  # POST /oee_codes.json
  def create
    @oee_code = OeeCode.new(oee_code_params)
    # authorize(@oee_code)
    respond_to do |format|
      if @oee_code.save
        format.html { redirect_to @oee_code, notice: 'Oee code was successfully created.' }
        format.json { render :show, status: :created, location: @oee_code }
      else
        format.html { render :new }
        format.json { render json: @oee_code.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /oee_codes/1
  # PATCH/PUT /oee_codes/1.json
  def update
    respond_to do |format|
      if @oee_code.update(oee_code_params)
        format.html { redirect_to @oee_code, notice: 'Oee code was successfully updated.' }
        format.json { render :show, status: :ok, location: @oee_code }
      else
        format.html { render :edit }
        format.json { render json: @oee_code.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /oee_codes/1
  # DELETE /oee_codes/1.json
  def destroy
    @oee_code.destroy
    respond_to do |format|
      format.html { redirect_to oee_codes_url, notice: 'Oee code was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_oee_code
      @oee_code = OeeCode.find(params[:id])
      # authorize(@oee_code)
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def oee_code_params
      params.require(:oee_code).permit(:nr,:description)
    end
end

class MachineCombinationsController < ApplicationController
  before_action :set_machine_combination, only: [:edit, :update, :destroy]
  before_action :set_machine, only: [:show, :new]
  before_action :set_machine_combinations, only: [:show]

  # GET /machine_combinations
  # GET /machine_combinations.json
  def index
    @machine_combinations = MachineCombination.all
  end

  # GET /machine_combinations/1
  # GET /machine_combinations/1.json
  def show
    @machine_combination = MachineCombination.new
  end

  # GET /machine_combinations/new
  def new
    @machine_combination = MachineCombination.new
  end

  # GET /machine_combinations/1/edit
  def edit
  end

  # POST /machine_combinations
  # POST /machine_combinations.json
  def create
    @machine_combination = MachineCombination.new(machine_combination_params)

    respond_to do |format|
      if @machine_combination.save
        format.html { redirect_to @machine_combination, notice: 'Machine combination was successfully created.' }
        format.json { render :show, status: :created, location: @machine_combination }
      else
        format.html { render :new }
        format.json { render json: @machine_combination.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /machine_combinations/1
  # PATCH/PUT /machine_combinations/1.json
  def update
    respond_to do |format|
      if @machine_combination.update(machine_combination_params)
        format.html { redirect_to @machine_combination, notice: 'Machine combination was successfully updated.' }
        format.json { render :show, status: :ok, location: @machine_combination }
      else
        format.html { render :edit }
        format.json { render json: @machine_combination.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /machine_combinations/1
  # DELETE /machine_combinations/1.json
  def destroy
    @machine_combination.destroy
    respond_to do |format|
      format.html { redirect_to machine_combinations_url, notice: 'Machine combination was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
  def set_machine
    unless (@machine=Machine.find_by_id(params[:machine_id])) && (@machine_scope=@machine.machine_scope)
      redirect_to machines_path, notice: 'Please select a machine'
    end
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_machine_combination
    @machine_combination = MachineCombination.find(params[:id])
  end

  def set_machine_combinations
    @machine_combinations = Machine.find_by_id(params[:machine_id]).machine_combinations
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def machine_combination_params
    params.require(:machine_combination).permit(:w1, :t1, :t2, :s1, :s2, :wd1, :w2, :t3, :t4, :s3, :s4, :wd2, :machine_id)
  end
end

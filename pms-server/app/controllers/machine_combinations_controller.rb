class MachineCombinationsController < ApplicationController
  before_action :set_machine_combination, only: [:edit, :update, :destroy]
  before_action :set_machine, only: [:show, :new]
  before_action :set_machine_combinations, only: [:show]
  before_action :prepare_machine_combination_params, only: [:create, :update]
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
    respond_to do |format|
      if @machine_combination.errors.empty? && @machine_combination.save
        flash.clear
        format.html { redirect_to machine_machine_combinations_path(@machine), notice: 'Machine combination was successfully created.' }
        format.json { render :show, status: :created, location: @machine_combination }
      else
        format.html { redirect_to machine_machine_combinations_path(@machine), notice: @machine_combination.errors.to_json } #.collect { |e| e[1] }.to_json }
        format.json { render json: @machine_combination.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /machine_combinations/1
  # PATCH/PUT /machine_combinations/1.json
  def update
    respond_to do |format|
      if @machine_combination.errors.empty? && @machine_combination.save
        flash.clear
        format.html { redirect_to machine_machine_combinations_path(@machine), notice: 'Machine combination was successfully updated.' }
        format.json { render :show, status: :created, location: @machine_combination }
      else
        format.html { redirect_to machine_machine_combinations_path(@machine), notice: @machine_combination.errors.to_json }
        format.json { render json: @machine_combination.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /machine_combinations/1
  # DELETE /machine_combinations/1.json
  def destroy
    @machine_combination.destroy
    respond_to do |format|
      format.html { redirect_to machine_machine_combinations_path(@machine_combination.machine), notice: 'Machine combination was successfully destroyed.' }
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
    @machine_combinations = MachineCombinationPresenter.init_presenters(Machine.find_by_id(params[:machine_id]).machine_combinations)
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def machine_combination_params
    params.require(:machine_combination).permit(:w1, :t1, :t2, :s1, :s2, :wd1, :w2, :t3, :t4, :s3, :s4, :wd2, :machine_id)
  end

  def prepare_machine_combination_params
    mp=machine_combination_params
    @machine=Machine.find_by_id(params[:machine_combination][:machine_id])
    if action_name=='create'
      @machine_combination = MachineCombination.new(mp) if action_name=='create'

      mp.keys.each { |k|
        flash[k]=mp[k]
      }
    end

    [:wd1, :wd2].each do |field|
      @machine_combination.send("#{field}=", mp[field].blank? ? nil : mp[field])
    end

    [:w1, :t1, :t2, :s1, :s2, :w2, :t3, :t4, :s3, :s4].each do |field|
      if (part=Part.find_by_nr(mp[field]))
        @machine_combination.send("#{field}=", part.id)
      else
        if (action_name=='create') || (action_name=='update' && !@machine_combination.send("#{field}").nil? && mp[field].blank?)
          @machine_combination.send("#{field}=", nil)
        end
        @machine_combination.errors.add(field, "part: #{mp[field]}, no exists") unless mp[field].blank?
      end
    end
  end

end

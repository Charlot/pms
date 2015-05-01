class MachineScopesController < ApplicationController
  before_action :set_machine_scope, only: [:show, :edit, :update, :destroy]
  before_action :set_machine, only: [:new]
  # GET /machine_scopes
  # GET /machine_scopes.json
  def index
    @machine_scopes = MachineScope.all
  end

  # GET /machine_scopes/1
  # GET /machine_scopes/1.json
  def show
  end

  # GET /machine_scopes/new
  def new
    @machine_scope = MachineScope.new
    authorize(@machine_scope)
  end

  # GET /machine_scopes/1/edit
  def edit
  end

  # POST /machine_scopes
  # POST /machine_scopes.json
  def create
    @machine_scope = MachineScope.new(machine_scope_params)
    authorize(@machine_scope)
    respond_to do |format|
      if @machine_scope.save
        format.html { redirect_to @machine_scope, notice: 'Machine scope was successfully created.' }
        format.json { render :show, status: :created, location: @machine_scope }
      else
        format.html { render :new }
        format.json { render json: @machine_scope.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /machine_scopes/1
  # PATCH/PUT /machine_scopes/1.json
  def update
    respond_to do |format|
      if @machine_scope.update(machine_scope_params)
        format.html { redirect_to @machine_scope, notice: 'Machine scope was successfully updated.' }
        format.json { render :show, status: :ok, location: @machine_scope }
      else
        format.html { render :edit }
        format.json { render json: @machine_scope.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /machine_scopes/1
  # DELETE /machine_scopes/1.json
  def destroy
    @machine_scope.destroy
    respond_to do |format|
      format.html { redirect_to machine_scopes_url, notice: 'Machine scope was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
  def set_machine
    unless @machine=Machine.find_by_id(params[:machine_id])
      redirect_to machines_path, notice: 'Please select a machine'
    end
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_machine_scope
    @machine_scope = params.has_key?(:machine_id) ? Machine.find_by_id(params[:machine_id]).machine_scope : MachineScope.find(params[:id])
    authorize(@machine_scope)
    @machine=@machine_scope.machine
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def machine_scope_params
    params.require(:machine_scope).permit(:w1, :t1, :t2, :s1, :s2, :wd1, :w2, :t3, :t4, :s3, :s4, :wd2, :machine_id)
  end

end

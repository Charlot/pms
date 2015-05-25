class ResourceGroupMachinesController < ApplicationController
  before_action :set_resource_group_machine, only: [:show, :edit, :update, :destroy]

  # GET /resource_group_machines
  # GET /resource_group_machines.json
  def index
    @resource_group_machines = ResourceGroupMachine.all
  end

  # GET /resource_group_machines/1
  # GET /resource_group_machines/1.json
  def show
  end

  # GET /resource_group_machines/new
  def new
    @resource_group_machine = ResourceGroupMachine.new
    #authorize(@resource_group_machine)
  end

  # GET /resource_group_machines/1/edit
  def edit
  end

  # POST /resource_group_machines
  # POST /resource_group_machines.json
  def create
    @resource_group_machine = ResourceGroupMachine.new(resource_group_machine_params)
    #authorize(@resource_group_machine)
    respond_to do |format|
      if @resource_group_machine.save
        format.html { redirect_to @resource_group_machine, notice: 'Resource group machine was successfully created.' }
        format.json { render :show, status: :created, location: @resource_group_machine }
      else
        format.html { render :new }
        format.json { render json: @resource_group_machine.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /resource_group_machines/1
  # PATCH/PUT /resource_group_machines/1.json
  def update
    respond_to do |format|
      if @resource_group_machine.update(resource_group_machine_params)
        format.html { redirect_to @resource_group_machine, notice: 'Resource group machine was successfully updated.' }
        format.json { render :show, status: :ok, location: @resource_group_machine }
      else
        format.html { render :edit }
        format.json { render json: @resource_group_machine.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /resource_group_machines/1
  # DELETE /resource_group_machines/1.json
  def destroy
    @resource_group_machine.destroy
    respond_to do |format|
      format.html { redirect_to resource_group_machines_url, notice: 'Resource group machine was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_resource_group_machine
      @resource_group_machine = ResourceGroupMachine.find(params[:id])
      #authorize(@resource_group_machine)
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def resource_group_machine_params
      params.require(:resource_group_machine).permit(:nr, :type, :name, :description)
    end
end

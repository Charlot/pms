class ResourceGroupsController < ApplicationController
  before_action :set_resource_group, only: [:show, :edit, :update, :destroy]

  # GET /resource_groups
  # GET /resource_groups.json
  def index
    @resource_groups = ResourceGroup.all
  end

  # GET /resource_groups/1
  # GET /resource_groups/1.json
  def show
  end

  # GET /resource_groups/new
  def new
    @resource_group = ResourceGroup.new
    authorize(@resource_group)
  end

  # GET /resource_groups/1/edit
  def edit
  end

  # POST /resource_groups
  # POST /resource_groups.json
  def create
    @resource_group = ResourceGroup.new(resource_group_params)

    respond_to do |format|
      if @resource_group.save
        format.html { redirect_to @resource_group, notice: 'Resource group was successfully created.' }
        format.json { render :show, status: :created, location: @resource_group }
      else
        format.html { render :new }
        format.json { render json: @resource_group.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /resource_groups/1
  # PATCH/PUT /resource_groups/1.json
  def update
    respond_to do |format|
      if @resource_group.update(resource_group_params)
        format.html { redirect_to @resource_group, notice: 'Resource group was successfully updated.' }
        format.json { render :show, status: :ok, location: @resource_group }
      else
        format.html { render :edit }
        format.json { render json: @resource_group.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /resource_groups/1
  # DELETE /resource_groups/1.json
  def destroy
    @resource_group.destroy
    respond_to do |format|
      format.html { redirect_to resource_groups_url, notice: 'Resource group was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_resource_group
      @resource_group = ResourceGroup.find(params[:id])
      authorize(@resource_group)
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def resource_group_params
      params.require(:resource_group).permit(:nr, :type, :name, :description)
    end
end

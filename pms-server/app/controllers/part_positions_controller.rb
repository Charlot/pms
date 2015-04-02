class PartPositionsController < ApplicationController
  before_action :set_part_position, only: [:show, :edit, :update, :destroy]

  # GET /part_positions
  # GET /part_positions.json
  def index
    @part_positions = PartPosition.all
  end

  # GET /part_positions/1
  # GET /part_positions/1.json
  def show
  end

  # GET /part_positions/new
  def new
    @part_position = PartPosition.new
  end

  # GET /part_positions/1/edit
  def edit
  end

  # POST /part_positions
  # POST /part_positions.json
  def create
    @part_position = PartPosition.new(part_position_params)

    respond_to do |format|
      if @part_position.save
        format.html { redirect_to @part_position, notice: 'Part position was successfully created.' }
        format.json { render :show, status: :created, location: @part_position }
      else
        format.html { render :new }
        format.json { render json: @part_position.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /part_positions/1
  # PATCH/PUT /part_positions/1.json
  def update
    respond_to do |format|
      if @part_position.update(part_position_params)
        format.html { redirect_to @part_position, notice: 'Part position was successfully updated.' }
        format.json { render :show, status: :ok, location: @part_position }
      else
        format.html { render :edit }
        format.json { render json: @part_position.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /part_positions/1
  # DELETE /part_positions/1.json
  def destroy
    @part_position.destroy
    respond_to do |format|
      format.html { redirect_to part_positions_url, notice: 'Part position was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  # GET/POST
  def import

  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_part_position
      @part_position = PartPosition.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def part_position_params
      params[:part_position]
    end
end

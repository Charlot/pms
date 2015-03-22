class ProductionOrderItemsController < ApplicationController
  before_action :set_production_order_item, only: [:show, :edit, :update, :destroy]

  # GET /production_order_items
  # GET /production_order_items.json
  def index
    if params.has_key?(:production_order_id)
      @production_order=ProductionOrder.find_by_id(params[:production_order_id])
      @production_order_items=@production_order.production_order_items
      @optimised=true
    else
      @production_order_items = ProductionOrderItem.for_optimise
    end
  end

  # GET /production_order_items/1
  # GET /production_order_items/1.json
  def show
  end

  # GET /production_order_items/new
  def new
    @production_order_item = ProductionOrderItem.new
  end

  # GET /production_order_items/1/edit
  def edit
  end

  # POST /production_order_items
  # POST /production_order_items.json
  def create
    @production_order_item = ProductionOrderItem.new(production_order_item_params)

    respond_to do |format|
      if @production_order_item.save
        format.html { redirect_to @production_order_item, notice: 'Production order item was successfully created.' }
        format.json { render :show, status: :created, location: @production_order_item }
      else
        format.html { render :new }
        format.json { render json: @production_order_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /production_order_items/1
  # PATCH/PUT /production_order_items/1.json
  def update
    respond_to do |format|
      if @production_order_item.update(production_order_item_params)
        format.html { redirect_to @production_order_item, notice: 'Production order item was successfully updated.' }
        format.json { render :show, status: :ok, location: @production_order_item }
      else
        format.html { render :edit }
        format.json { render json: @production_order_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /production_order_items/1
  # DELETE /production_order_items/1.json
  def destroy
    @production_order_item.destroy
    respond_to do |format|
      format.html { redirect_to production_order_items_url, notice: 'Production order item was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  # POST
  # optimize production order item to machine by machine combinations
  # and create production order
  def optimise
    begin
      if ProductionOrderItem.for_optimise.count>0
        if order= ProductionOrderItem.optimise
          redirect_to production_order_production_order_items_path(order), notice: 'Optimise Success'
        else
          # raise
          redirect_to production_order_items_path, notice: 'Optimise Fail'
        end
      else
        redirect_to production_order_items_path, notice: 'No Item For Optimise'
      end
    rescue => e
      raise e
    end
  end

  # POST
  # distribute production order item to machine
  def distribute
    msg=Message.new
    if @production_order=ProductionOrder.find_by_id(params[:production_order_id])
      puts "#{@production_order.class}--------------------------------"

      msg=Ncr::Order.new(@production_order).distribute
      redirect_to production_order_production_order_items_path(@production_order), notice: msg.content
    else
      msg.content = 'Production Order Not found Error'
      redirect_to production_order_items_path, notice: msg.content
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_production_order_item
    @production_order_item = ProductionOrderItem.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def production_order_item_params
    params.require(:production_order_item).permit(:nr, :state, :code, :kanban_id, :production_order)
  end
end

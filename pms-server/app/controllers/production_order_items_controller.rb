class ProductionOrderItemsController < ApplicationController
  before_action :set_production_order_item, only: [:show, :edit, :update, :destroy]

  # GET /production_order_items
  # GET /production_order_items.json
  def index
    if params.has_key?(:production_order_id)
      @production_order=ProductionOrder.find_by_id(params[:production_order_id])
      @production_order_items=@production_order.production_order_items.order(machine_id: :asc, optimise_index: :asc).paginate(:page => params[:page])
      @optimised=true
    else
      @production_order_items = ProductionOrderItem.for_optimise.paginate(:page => params[:page])
    end
    @page = params[:page].blank? ? 0 : (params[:page].to_i-1)
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

  # POST
  def export
    if @production_order=ProductionOrder.find_by_id(params[:production_order_id])
      items=ProductionOrderItem.for_export(@production_order)
      msg=FileHandler::Csv::ProductionOrderItemHandler.new.export_optimized(items, request.user_agent)
      if msg.result
        send_file msg.content
      else
        @content = msg.to_json
        render 'shared/error'
        #render json: msg
      end
    else
      @content = "未找到"
      render 'shared/error'
    end
  end

  def state_export
    if request.post?
      msg=FileHandler::Csv::ProductionOrderItemHandler.new.export_by_state(params, request.user_agent)
      if msg.result
        send_file msg.content
      else
        @content = msg.to_json
        render 'shared/error'
        #render json: msg
      end
    end
  end

  def search
    @production_order_items=nil
    if params.has_key?(:production_order_id) && params[:production_order_id].length>0
      @production_order=ProductionOrder.find_by_id(params[:production_order_id])
      @production_order_items=@production_order.production_order_items.order(machine_id: :asc, optimise_index: :asc)
      @optimised=true
    else
      @production_order_items = ProductionOrderItem.for_optimise
    end

    if params.has_key?(:machine_nr) && params[:machine_nr].length>0
      @production_order_items= @production_order_items.joins(:machine).where(machines: {nr: params[:machine_nr]})
      @machine_nr=params[:machine_nr]
    end
    if params.has_key?(:production_order_item_nr) && params[:production_order_item_nr].length>0
      @production_order_items= @production_order_items.where("production_order_items.nr like '%#{params[:production_order_item_nr]}%'")
      @production_order_item_nr=params[:production_order_item_nr]
    end
    @production_order_items= @production_order_items.paginate(:page => params[:page])
    @page = params[:page].blank? ? 0 : (params[:page].to_i-1)
    render :index
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_production_order_item
    @production_order_item = ProductionOrderItem.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def production_order_item_params
    params.require(:production_order_item).permit(:nr, :state, :optimise_index, :production_order_id, :code, :kanban_id, :machine_id, :production_order)
  end
end

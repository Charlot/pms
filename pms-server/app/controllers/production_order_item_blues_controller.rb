class ProductionOrderItemBluesController < ApplicationController
  before_action :set_production_order_item_blue, only: [:show, :edit, :update, :destroy]

  # GET /production_order_items
  # GET /production_order_items.json
  def index
    if params.has_key?(:production_order_blue_id)
      @production_order=ProductionOrderBlue.find_by_id(params[:production_order_blue_id])
      @production_order_items=@production_order.production_order_item_blues.paginate(:page => params[:page])
    else
      @production_order_items = ProductionOrderItemBlue.for_distribute.paginate(:page => params[:page])
    end
    @page = params[:page].blank? ? 0 : (params[:page].to_i-1)
  end


  # PATCH/PUT /production_order_items/1
  # PATCH/PUT /production_order_items/1.json
  def update
    #authorize(@production_order_item)
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

  def distribute
    #authorize(ProductionOrderItem)
    msg=Message.new
    if ProductionOrderItemBlue.has_for_distribute?
      order_operate=Ncr::Order.new(nil, ProductionOrderType::BLUE)
      msg=order_operate.distribute
      if msg.result
        redirect_to production_order_blue_production_order_item_blues_path(order_operate.production_order), notice: msg.content
      else
        redirect_to production_order_item_blues_path, notice: msg.content
      end
    else
      msg.content = '不存在需要优化项'
      redirect_to production_order_items_path, notice: msg.content
    end
  end


  def export_scand
    #authorize(ProductionOrderItem)
    items=ProductionOrderItemBlue.for_distribute
    msg=FileHandler::Excel::ProductionOrderItemBlueHandler.export(items)
    if msg.result
      send_file msg.content
    else
      @content = msg.to_json
      render 'shared/error'
    end
  end


  def search
    #authorize(ProductionOrderItem)
    @production_order_items=ProductionOrderItemBlue

    if params.has_key?(:production_order_item_nr) && params[:production_order_item_nr].length>0
      @production_order_items= @production_order_items.where("production_order_items.nr like '%#{params[:production_order_item_nr]}%'")
      @production_order_item_nr=params[:production_order_item_nr]
    end

    unless params[:kanban_nr].blank?
      @production_order_items=@production_order_items.joins(:kanban).where("kanbans.nr like ?", "%#{params[:kanban_nr]}%")
      @kanban_nr=params[:kanban_nr]
    end
    unless params[:state].blank?
      @production_order_items=@production_order_items.where(state: params[:state])
      @state=params[:state]
    end
    @production_order_items= @production_order_items.paginate(:page => params[:page])
    @page = params[:page].blank? ? 0 : (params[:page].to_i-1)
    render :index
  end


  # DELETE /production_order_items/1
  # DELETE /production_order_items/1.json
  def destroy
    #authorize(@production_order_item)
    @production_order_item.destroy
    respond_to do |format|
      format.html { redirect_to production_order_item_blues_path, notice: 'Production order item was successfully destroyed.' }
      format.json { head :no_content }
    end
  end


  def search
    @production_order_items = ProductionOrderItemBlue.all

    if params.has_key?(:production_order_item_nr) && params[:production_order_item_nr].length>0
      @production_order_items= @production_order_items.where("production_order_items.nr like '%#{params[:production_order_item_nr]}%'")
      @production_order_item_nr=params[:production_order_item_nr]
    end

    unless params[:kanban_nr].blank?
      @production_order_items=@production_order_items.joins(:kanban).where("kanbans.nr like ?", "%#{params[:kanban_nr]}%")
      @kanban_nr=params[:kanban_nr]
    end

    unless params[:state].blank?
      @production_order_items=@production_order_items.where(state: params[:state])
      @state=params[:state]
    end
    @production_order_items= @production_order_items.paginate(:page => params[:page])
    @page = params[:page].blank? ? 0 : (params[:page].to_i-1)
    render :index
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_production_order_item_blue
    @production_order_item = ProductionOrderItemBlue.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def production_order_item_params
    params.require(:production_order_item_blue).permit(:nr, :produced_qty, :state, :optimise_index, :production_order_id, :code, :kanban_id, :machine_id, :production_order)
  end
end

class ProductionOrderHandlerItemsController < ApplicationController
  before_action :set_production_order_handler_item, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @production_order_handler_items = ProductionOrderHandlerItem.all
    respond_with(@production_order_handler_items)
  end

  def show
    respond_with(@production_order_handler_item)
  end

  def new
    @production_order_handler_item = ProductionOrderHandlerItem.new
    respond_with(@production_order_handler_item)
  end

  def edit
  end

  def create
    @production_order_handler_item = ProductionOrderHandlerItem.new(production_order_handler_item_params)
    @production_order_handler_item.save
    respond_with(@production_order_handler_item)
  end

  def update
    @production_order_handler_item.update(production_order_handler_item_params)
    respond_with(@production_order_handler_item)
  end

  def destroy
    @production_order_handler_item.destroy
    respond_with(@production_order_handler_item)
  end

  private
    def set_production_order_handler_item
      @production_order_handler_item = ProductionOrderHandlerItem.find(params[:id])
    end

    def production_order_handler_item_params
      params.require(:production_order_handler_item).permit(:nr, :desc, :remark, :kanban_code, :kanban_nr, :result, :handler_user, :item_terminated_at, :production_order_handler_id)
    end
end

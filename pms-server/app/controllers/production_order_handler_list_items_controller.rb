class ProductionOrderHandlerListItemsController < ApplicationController
  before_action :set_production_order_handler_list_item, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @production_order_handler_list_items = ProductionOrderHandlerListItem.all
    respond_with(@production_order_handler_list_items)
  end

  def show
    respond_with(@production_order_handler_list_item)
  end

  def new
    @production_order_handler_list_item = ProductionOrderHandlerListItem.new
    respond_with(@production_order_handler_list_item)
  end

  def edit
  end

  def create
    @production_order_handler_list_item = ProductionOrderHandlerListItem.new(production_order_handler_list_item_params)
    @production_order_handler_list_item.save
    respond_with(@production_order_handler_list_item)
  end

  def update
    @production_order_handler_list_item.update(production_order_handler_list_item_params)
    respond_with(@production_order_handler_list_item)
  end

  def destroy
    @production_order_handler_list_item.destroy
    respond_with(@production_order_handler_list_item)
  end

  private
    def set_production_order_handler_list_item
      @production_order_handler_list_item = ProductionOrderHandlerListItem.find(params[:id])
    end

    def production_order_handler_list_item_params
      params.require(:production_order_handler_list_item).permit(:nr, :desc, :kanban_code, :kanban_nr, :result, :handler_user, :item_terminated_at, :production_order_handler_list_id)
    end
end

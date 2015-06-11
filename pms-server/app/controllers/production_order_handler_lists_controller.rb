class ProductionOrderHandlerListsController < ApplicationController
  before_action :set_production_order_handler_list, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @production_order_handler_lists = ProductionOrderHandlerList.all
    respond_with(@production_order_handler_lists)
  end

  def show
    respond_with(@production_order_handler_list)
  end

  def new
    @production_order_handler_list = ProductionOrderHandlerList.new
    respond_with(@production_order_handler_list)
  end

  def edit
  end

  def create
    @production_order_handler_list = ProductionOrderHandlerList.new(production_order_handler_list_params)
    @production_order_handler_list.save
    respond_with(@production_order_handler_list)
  end

  def update
    @production_order_handler_list.update(production_order_handler_list_params)
    respond_with(@production_order_handler_list)
  end

  def destroy
    @production_order_handler_list.destroy
    respond_with(@production_order_handler_list)
  end

  private
    def set_production_order_handler_list
      @production_order_handler_list = ProductionOrderHandlerList.find(params[:id])
    end

    def production_order_handler_list_params
      params.require(:production_order_handler_list).permit(:nr, :desc)
    end
end

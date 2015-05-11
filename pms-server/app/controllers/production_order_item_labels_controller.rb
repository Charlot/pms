class ProductionOrderItemLabelsController < ApplicationController
  before_action :set_production_order_item_label, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @production_order_item_labels = ProductionOrderItemLabel.all
    respond_with(@production_order_item_labels)
  end

  def show
    respond_with(@production_order_item_label)
  end

  def new
    @production_order_item_label = ProductionOrderItemLabel.new
    respond_with(@production_order_item_label)
  end

  def edit
  end

  def create
    @production_order_item_label = ProductionOrderItemLabel.new(production_order_item_label_params)
    @production_order_item_label.save
    respond_with(@production_order_item_label)
  end

  def update
    @production_order_item_label.update(production_order_item_label_params)
    respond_with(@production_order_item_label)
  end

  def destroy
    @production_order_item_label.destroy
    respond_with(@production_order_item_label)
  end

  private
    def set_production_order_item_label
      @production_order_item_label = ProductionOrderItemLabel.find(params[:id])
    end

    def production_order_item_label_params
      params.require(:production_order_item_label).permit(:production_order_item_id, :bundle_no, :qty, :nr, :state)
    end
end

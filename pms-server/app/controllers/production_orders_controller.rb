class ProductionOrdersController < ApplicationController
  before_action :set_production_order, only: [:show, :edit, :update, :destroy]

  # GET /production_orders
  # GET /production_orders.json
  def index
    @production_orders = ProductionOrder.paginate(:page => params[:page])
  end

  # GET /production_orders/1
  # GET /production_orders/1.json
  def show
  end

  # GET /production_orders/new
  def new
    @production_order = ProductionOrder.new
  end

  # GET /production_orders/1/edit
  def edit
  end

  # POST /production_orders
  # POST /production_orders.json
  def create
    @production_order = ProductionOrder.new(production_order_params)

    respond_to do |format|
      if @production_order.save
        format.html { redirect_to @production_order, notice: 'Production order was successfully created.' }
        format.json { render :show, status: :created, location: @production_order }
      else
        format.html { render :new }
        format.json { render json: @production_order.errors, status: :unprocessable_entity }
      end
    end
  end

  # GET /production_orders/preview
  def preview
    @machine = params[:machine_nr].nil? ? Machine.first : Machine.find_by_nr(params[:machine_nr])
    if params[:machine_nr] == 'All'
      @machine_nr = 'All'
      @production_order_items = ProductionOrderItemPresenter.init_preview_presenters(ProductionOrderItem.for_produce.all)
    else
      @production_order_items = ProductionOrderItemPresenter.init_preview_presenters(ProductionOrderItem.for_produce(@machine).all)
    end

    #item = @production_order_items.first
    #puts "^^^^^^^^^^^^^^^^^^^^"
    #puts item[:No]
  end

  # PATCH/PUT /production_orders/1
  # PATCH/PUT /production_orders/1.json
  def update
    respond_to do |format|
      if @production_order.update(production_order_params)
        format.html { redirect_to @production_order, notice: 'Production order was successfully updated.' }
        format.json { render :show, status: :ok, location: @production_order }
      else
        format.html { render :edit }
        format.json { render json: @production_order.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /production_orders/1
  # DELETE /production_orders/1.json
  def destroy
    @production_order.destroy
    respond_to do |format|
      format.html { redirect_to production_orders_url, notice: 'Production order was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_production_order
      @production_order = ProductionOrder.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def production_order_params
      params.require(:production_order).permit(:nr, :state)
    end
end

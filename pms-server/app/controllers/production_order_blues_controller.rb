class ProductionOrderBluesController<ApplicationController
  def index
    @production_orders = ProductionOrderBlue.paginate(:page => params[:page])
  end

end
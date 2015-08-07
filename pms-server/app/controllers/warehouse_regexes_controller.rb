class WarehouseRegexesController < ApplicationController
  before_action :set_warehouse_regex, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @warehouse_regexes = WarehouseRegex.all
    respond_with(@warehouse_regexes)
  end

  def show
    respond_with(@warehouse_regex)
  end

  def new
    @warehouse_regex = WarehouseRegex.new
    respond_with(@warehouse_regex)
  end

  def edit
  end

  def create
    @warehouse_regex = WarehouseRegex.new(warehouse_regex_params)
    @warehouse_regex.save
    respond_with(@warehouse_regex)
  end

  def update
    @warehouse_regex.update(warehouse_regex_params)
    respond_with(@warehouse_regex)
  end

  def destroy
    @warehouse_regex.destroy
    respond_with(@warehouse_regex)
  end

  private
    def set_warehouse_regex
      @warehouse_regex = WarehouseRegex.find(params[:id])
    end

    def warehouse_regex_params
      params.require(:warehouse_regex).permit(:regex, :warehouse_nr, :desc)
    end
end

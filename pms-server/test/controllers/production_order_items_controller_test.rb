require 'test_helper'

class ProductionOrderItemsControllerTest < ActionController::TestCase
  setup do
    @production_order_item = production_order_items(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:production_order_items)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create production_order_item" do
    assert_difference('ProductionOrderItem.count') do
      post :create, production_order_item: { code: @production_order_item.code, kanban_id: @production_order_item.kanban_id, nr: @production_order_item.nr, production_order: @production_order_item.production_order, state: @production_order_item.state }
    end

    assert_redirected_to production_order_item_path(assigns(:production_order_item))
  end

  test "should show production_order_item" do
    get :show, id: @production_order_item
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @production_order_item
    assert_response :success
  end

  test "should update production_order_item" do
    patch :update, id: @production_order_item, production_order_item: { code: @production_order_item.code, kanban_id: @production_order_item.kanban_id, nr: @production_order_item.nr, production_order: @production_order_item.production_order, state: @production_order_item.state }
    assert_redirected_to production_order_item_path(assigns(:production_order_item))
  end

  test "should destroy production_order_item" do
    assert_difference('ProductionOrderItem.count', -1) do
      delete :destroy, id: @production_order_item
    end

    assert_redirected_to production_order_items_path
  end
end

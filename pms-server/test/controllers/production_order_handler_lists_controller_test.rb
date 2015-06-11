require 'test_helper'

class ProductionOrderHandlerListsControllerTest < ActionController::TestCase
  setup do
    @production_order_handler_list = production_order_handler_lists(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:production_order_handler_lists)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create production_order_handler_list" do
    assert_difference('ProductionOrderHandlerList.count') do
      post :create, production_order_handler_list: { desc: @production_order_handler_list.desc, nr: @production_order_handler_list.nr }
    end

    assert_redirected_to production_order_handler_list_path(assigns(:production_order_handler_list))
  end

  test "should show production_order_handler_list" do
    get :show, id: @production_order_handler_list
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @production_order_handler_list
    assert_response :success
  end

  test "should update production_order_handler_list" do
    patch :update, id: @production_order_handler_list, production_order_handler_list: { desc: @production_order_handler_list.desc, nr: @production_order_handler_list.nr }
    assert_redirected_to production_order_handler_list_path(assigns(:production_order_handler_list))
  end

  test "should destroy production_order_handler_list" do
    assert_difference('ProductionOrderHandlerList.count', -1) do
      delete :destroy, id: @production_order_handler_list
    end

    assert_redirected_to production_order_handler_lists_path
  end
end

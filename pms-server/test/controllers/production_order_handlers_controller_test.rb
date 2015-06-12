require 'test_helper'

class ProductionOrderHandlersControllerTest < ActionController::TestCase
  setup do
    @production_order_handler = production_order_handlers(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:production_order_handlers)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create production_order_handler" do
    assert_difference('ProductionOrderHandler.count') do
      post :create, production_order_handler: { desc: @production_order_handler.desc, nr: @production_order_handler.nr, remark: @production_order_handler.remark }
    end

    assert_redirected_to production_order_handler_path(assigns(:production_order_handler))
  end

  test "should show production_order_handler" do
    get :show, id: @production_order_handler
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @production_order_handler
    assert_response :success
  end

  test "should update production_order_handler" do
    patch :update, id: @production_order_handler, production_order_handler: { desc: @production_order_handler.desc, nr: @production_order_handler.nr, remark: @production_order_handler.remark }
    assert_redirected_to production_order_handler_path(assigns(:production_order_handler))
  end

  test "should destroy production_order_handler" do
    assert_difference('ProductionOrderHandler.count', -1) do
      delete :destroy, id: @production_order_handler
    end

    assert_redirected_to production_order_handlers_path
  end
end

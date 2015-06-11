require 'test_helper'

class ProductionOrderHandlerListItemsControllerTest < ActionController::TestCase
  setup do
    @production_order_handler_list_item = production_order_handler_list_items(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:production_order_handler_list_items)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create production_order_handler_list_item" do
    assert_difference('ProductionOrderHandlerListItem.count') do
      post :create, production_order_handler_list_item: { desc: @production_order_handler_list_item.desc, handler_user: @production_order_handler_list_item.handler_user, item_terminated_at: @production_order_handler_list_item.item_terminated_at, kanban_code: @production_order_handler_list_item.kanban_code, kanban_nr: @production_order_handler_list_item.kanban_nr, nr: @production_order_handler_list_item.nr, production_order_handler_list_id: @production_order_handler_list_item.production_order_handler_list_id, result: @production_order_handler_list_item.result }
    end

    assert_redirected_to production_order_handler_list_item_path(assigns(:production_order_handler_list_item))
  end

  test "should show production_order_handler_list_item" do
    get :show, id: @production_order_handler_list_item
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @production_order_handler_list_item
    assert_response :success
  end

  test "should update production_order_handler_list_item" do
    patch :update, id: @production_order_handler_list_item, production_order_handler_list_item: { desc: @production_order_handler_list_item.desc, handler_user: @production_order_handler_list_item.handler_user, item_terminated_at: @production_order_handler_list_item.item_terminated_at, kanban_code: @production_order_handler_list_item.kanban_code, kanban_nr: @production_order_handler_list_item.kanban_nr, nr: @production_order_handler_list_item.nr, production_order_handler_list_id: @production_order_handler_list_item.production_order_handler_list_id, result: @production_order_handler_list_item.result }
    assert_redirected_to production_order_handler_list_item_path(assigns(:production_order_handler_list_item))
  end

  test "should destroy production_order_handler_list_item" do
    assert_difference('ProductionOrderHandlerListItem.count', -1) do
      delete :destroy, id: @production_order_handler_list_item
    end

    assert_redirected_to production_order_handler_list_items_path
  end
end

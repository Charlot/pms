require 'test_helper'

class MasterBomItemsControllerTest < ActionController::TestCase
  setup do
    @master_bom_item = master_bom_items(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:master_bom_items)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create master_bom_item" do
    assert_difference('MasterBomItem.count') do
      post :create, master_bom_item: { bom_item_id: @master_bom_item.bom_item_id, department_id: @master_bom_item.department_id, product_id: @master_bom_item.product_id, qty: @master_bom_item.qty }
    end

    assert_redirected_to master_bom_item_path(assigns(:master_bom_item))
  end

  test "should show master_bom_item" do
    get :show, id: @master_bom_item
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @master_bom_item
    assert_response :success
  end

  test "should update master_bom_item" do
    patch :update, id: @master_bom_item, master_bom_item: { bom_item_id: @master_bom_item.bom_item_id, department_id: @master_bom_item.department_id, product_id: @master_bom_item.product_id, qty: @master_bom_item.qty }
    assert_redirected_to master_bom_item_path(assigns(:master_bom_item))
  end

  test "should destroy master_bom_item" do
    assert_difference('MasterBomItem.count', -1) do
      delete :destroy, id: @master_bom_item
    end

    assert_redirected_to master_bom_items_path
  end
end

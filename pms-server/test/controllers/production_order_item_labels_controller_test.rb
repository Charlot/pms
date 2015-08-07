require 'test_helper'

class ProductionOrderItemLabelsControllerTest < ActionController::TestCase
  setup do
    @production_order_item_label = production_order_item_labels(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:production_order_item_labels)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create production_order_item_label" do
    assert_difference('ProductionOrderItemLabel.count') do
      post :create, production_order_item_label: { bundle_no: @production_order_item_label.bundle_no, nr: @production_order_item_label.nr, production_order_item_id: @production_order_item_label.production_order_item_id, qty: @production_order_item_label.qty, state: @production_order_item_label.state }
    end

    assert_redirected_to production_order_item_label_path(assigns(:production_order_item_label))
  end

  test "should show production_order_item_label" do
    get :show, id: @production_order_item_label
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @production_order_item_label
    assert_response :success
  end

  test "should update production_order_item_label" do
    patch :update, id: @production_order_item_label, production_order_item_label: { bundle_no: @production_order_item_label.bundle_no, nr: @production_order_item_label.nr, production_order_item_id: @production_order_item_label.production_order_item_id, qty: @production_order_item_label.qty, state: @production_order_item_label.state }
    assert_redirected_to production_order_item_label_path(assigns(:production_order_item_label))
  end

  test "should destroy production_order_item_label" do
    assert_difference('ProductionOrderItemLabel.count', -1) do
      delete :destroy, id: @production_order_item_label
    end

    assert_redirected_to production_order_item_labels_path
  end
end

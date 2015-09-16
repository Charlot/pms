require 'test_helper'

class CrimpConfigurationItemsControllerTest < ActionController::TestCase
  setup do
    @crimp_configuration_item = crimp_configuration_items(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:crimp_configuration_items)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create crimp_configuration_item" do
    assert_difference('CrimpConfigurationItem.count') do
      post :create, crimp_configuration_item: { crimp_height: @crimp_configuration_item.crimp_height, crimp_height_iso: @crimp_configuration_item.crimp_height_iso, crimp_width: @crimp_configuration_item.crimp_width, crimp_width_iso: @crimp_configuration_item.crimp_width_iso, i_crimp_height: @crimp_configuration_item.i_crimp_height, i_crimp_height_iso: @crimp_configuration_item.i_crimp_height_iso, i_crimp_width: @crimp_configuration_item.i_crimp_width, i_crimp_width_iso: @crimp_configuration_item.i_crimp_width_iso, min_pulloff: @crimp_configuration_item.min_pulloff, side: @crimp_configuration_item.side }
    end

    assert_redirected_to crimp_configuration_item_path(assigns(:crimp_configuration_item))
  end

  test "should show crimp_configuration_item" do
    get :show, id: @crimp_configuration_item
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @crimp_configuration_item
    assert_response :success
  end

  test "should update crimp_configuration_item" do
    patch :update, id: @crimp_configuration_item, crimp_configuration_item: { crimp_height: @crimp_configuration_item.crimp_height, crimp_height_iso: @crimp_configuration_item.crimp_height_iso, crimp_width: @crimp_configuration_item.crimp_width, crimp_width_iso: @crimp_configuration_item.crimp_width_iso, i_crimp_height: @crimp_configuration_item.i_crimp_height, i_crimp_height_iso: @crimp_configuration_item.i_crimp_height_iso, i_crimp_width: @crimp_configuration_item.i_crimp_width, i_crimp_width_iso: @crimp_configuration_item.i_crimp_width_iso, min_pulloff: @crimp_configuration_item.min_pulloff, side: @crimp_configuration_item.side }
    assert_redirected_to crimp_configuration_item_path(assigns(:crimp_configuration_item))
  end

  test "should destroy crimp_configuration_item" do
    assert_difference('CrimpConfigurationItem.count', -1) do
      delete :destroy, id: @crimp_configuration_item
    end

    assert_redirected_to crimp_configuration_items_path
  end
end

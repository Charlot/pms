require 'test_helper'

class PartBomsControllerTest < ActionController::TestCase
  setup do
    @part_bom = part_boms(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:part_boms)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create part_bom" do
    assert_difference('PartBom.count') do
      post :create, part_bom: { bom_item_id: @part_bom.bom_item_id, part_id: @part_bom.part_id, quantity: @part_bom.quantity }
    end

    assert_redirected_to part_bom_path(assigns(:part_bom))
  end

  test "should show part_bom" do
    get :show, id: @part_bom
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @part_bom
    assert_response :success
  end

  test "should update part_bom" do
    patch :update, id: @part_bom, part_bom: { bom_item_id: @part_bom.bom_item_id, part_id: @part_bom.part_id, quantity: @part_bom.quantity }
    assert_redirected_to part_bom_path(assigns(:part_bom))
  end

  test "should destroy part_bom" do
    assert_difference('PartBom.count', -1) do
      delete :destroy, id: @part_bom
    end

    assert_redirected_to part_boms_path
  end
end

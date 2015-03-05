require 'test_helper'

class ResourceGroupPartsControllerTest < ActionController::TestCase
  setup do
    @resource_group_part = resource_group_parts(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:resource_group_parts)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create resource_group_part" do
    assert_difference('ResourceGroupPart.count') do
      post :create, resource_group_part: { part_id: @resource_group_part.part_id, resource_group_id: @resource_group_part.resource_group_id }
    end

    assert_redirected_to resource_group_part_path(assigns(:resource_group_part))
  end

  test "should show resource_group_part" do
    get :show, id: @resource_group_part
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @resource_group_part
    assert_response :success
  end

  test "should update resource_group_part" do
    patch :update, id: @resource_group_part, resource_group_part: { part_id: @resource_group_part.part_id, resource_group_id: @resource_group_part.resource_group_id }
    assert_redirected_to resource_group_part_path(assigns(:resource_group_part))
  end

  test "should destroy resource_group_part" do
    assert_difference('ResourceGroupPart.count', -1) do
      delete :destroy, id: @resource_group_part
    end

    assert_redirected_to resource_group_parts_path
  end
end

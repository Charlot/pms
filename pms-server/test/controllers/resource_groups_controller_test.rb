require 'test_helper'

class ResourceGroupsControllerTest < ActionController::TestCase
  setup do
    @resource_group = resource_groups(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:resource_groups)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create resource_group" do
    assert_difference('ResourceGroup.count') do
      post :create, resource_group: { description: @resource_group.description, name: @resource_group.name, nr: @resource_group.nr, resource_group_type: @resource_group.resource_group_type }
    end

    assert_redirected_to resource_group_path(assigns(:resource_group))
  end

  test "should show resource_group" do
    get :show, id: @resource_group
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @resource_group
    assert_response :success
  end

  test "should update resource_group" do
    patch :update, id: @resource_group, resource_group: { description: @resource_group.description, name: @resource_group.name, nr: @resource_group.nr, resource_group_type: @resource_group.resource_group_type }
    assert_redirected_to resource_group_path(assigns(:resource_group))
  end

  test "should destroy resource_group" do
    assert_difference('ResourceGroup.count', -1) do
      delete :destroy, id: @resource_group
    end

    assert_redirected_to resource_groups_path
  end
end

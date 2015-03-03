require 'test_helper'

class ResourceGroupToolsControllerTest < ActionController::TestCase
  setup do
    @resource_group_tool = resource_group_tools(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:resource_group_tools)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create resource_group_tool" do
    assert_difference('ResourceGroupTool.count') do
      post :create, resource_group_tool: { description: @resource_group_tool.description, name: @resource_group_tool.name, nr: @resource_group_tool.nr, type: @resource_group_tool.type }
    end

    assert_redirected_to resource_group_tool_path(assigns(:resource_group_tool))
  end

  test "should show resource_group_tool" do
    get :show, id: @resource_group_tool
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @resource_group_tool
    assert_response :success
  end

  test "should update resource_group_tool" do
    patch :update, id: @resource_group_tool, resource_group_tool: { description: @resource_group_tool.description, name: @resource_group_tool.name, nr: @resource_group_tool.nr, type: @resource_group_tool.type }
    assert_redirected_to resource_group_tool_path(assigns(:resource_group_tool))
  end

  test "should destroy resource_group_tool" do
    assert_difference('ResourceGroupTool.count', -1) do
      delete :destroy, id: @resource_group_tool
    end

    assert_redirected_to resource_group_tools_path
  end
end

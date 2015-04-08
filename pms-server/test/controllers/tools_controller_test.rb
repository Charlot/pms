require 'test_helper'

class ToolsControllerTest < ActionController::TestCase
  setup do
    @tool = tools(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:tools)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create tool" do
    assert_difference('Tool.count') do
      post :create, tool: { mnt: @tool.mnt, nr: @tool.nr, part_id: @tool.part_id, resource_group_id: @tool.resource_group_id, rql: @tool.rql, rql_date: @tool.rql_date, tol: @tool.tol, used_days: @tool.used_days }
    end

    assert_redirected_to tool_path(assigns(:tool))
  end

  test "should show tool" do
    get :show, id: @tool
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @tool
    assert_response :success
  end

  test "should update tool" do
    patch :update, id: @tool, tool: { mnt: @tool.mnt, nr: @tool.nr, part_id: @tool.part_id, resource_group_id: @tool.resource_group_id, rql: @tool.rql, rql_date: @tool.rql_date, tol: @tool.tol, used_days: @tool.used_days }
    assert_redirected_to tool_path(assigns(:tool))
  end

  test "should destroy tool" do
    assert_difference('Tool.count', -1) do
      delete :destroy, id: @tool
    end

    assert_redirected_to tools_path
  end
end

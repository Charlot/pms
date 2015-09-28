require 'test_helper'

class PartToolsControllerTest < ActionController::TestCase
  setup do
    @part_tool = part_tools(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:part_tools)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create part_tool" do
    assert_difference('PartTool.count') do
      post :create, part_tool: { part_id: @part_tool.part_id, tool_id: @part_tool.tool_id }
    end

    assert_redirected_to part_tool_path(assigns(:part_tool))
  end

  test "should show part_tool" do
    get :show, id: @part_tool
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @part_tool
    assert_response :success
  end

  test "should update part_tool" do
    patch :update, id: @part_tool, part_tool: { part_id: @part_tool.part_id, tool_id: @part_tool.tool_id }
    assert_redirected_to part_tool_path(assigns(:part_tool))
  end

  test "should destroy part_tool" do
    assert_difference('PartTool.count', -1) do
      delete :destroy, id: @part_tool
    end

    assert_redirected_to part_tools_path
  end
end

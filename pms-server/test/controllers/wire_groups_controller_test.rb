require 'test_helper'

class WireGroupsControllerTest < ActionController::TestCase
  setup do
    @wire_group = wire_groups(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:wire_groups)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create wire_group" do
    assert_difference('WireGroup.count') do
      post :create, wire_group: { cross_section: @wire_group.cross_section, group_name: @wire_group.group_name, wire_type: @wire_group.wire_type }
    end

    assert_redirected_to wire_group_path(assigns(:wire_group))
  end

  test "should show wire_group" do
    get :show, id: @wire_group
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @wire_group
    assert_response :success
  end

  test "should update wire_group" do
    patch :update, id: @wire_group, wire_group: { cross_section: @wire_group.cross_section, group_name: @wire_group.group_name, wire_type: @wire_group.wire_type }
    assert_redirected_to wire_group_path(assigns(:wire_group))
  end

  test "should destroy wire_group" do
    assert_difference('WireGroup.count', -1) do
      delete :destroy, id: @wire_group
    end

    assert_redirected_to wire_groups_path
  end
end

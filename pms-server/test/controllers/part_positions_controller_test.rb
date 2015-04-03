require 'test_helper'

class PartPositionsControllerTest < ActionController::TestCase
  setup do
    @part_position = part_positions(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:part_positions)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create part_position" do
    assert_difference('PartPosition.count') do
      post :create, part_position: {  }
    end

    assert_redirected_to part_position_path(assigns(:part_position))
  end

  test "should show part_position" do
    get :show, id: @part_position
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @part_position
    assert_response :success
  end

  test "should update part_position" do
    patch :update, id: @part_position, part_position: {  }
    assert_redirected_to part_position_path(assigns(:part_position))
  end

  test "should destroy part_position" do
    assert_difference('PartPosition.count', -1) do
      delete :destroy, id: @part_position
    end

    assert_redirected_to part_positions_path
  end
end

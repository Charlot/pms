require 'test_helper'

class MachineTypesControllerTest < ActionController::TestCase
  setup do
    @machine_type = machine_types(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:machine_types)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create machine_type" do
    assert_difference('MachineType.count') do
      post :create, machine_type: { description: @machine_type.description, nr: @machine_type.nr }
    end

    assert_redirected_to machine_type_path(assigns(:machine_type))
  end

  test "should show machine_type" do
    get :show, id: @machine_type
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @machine_type
    assert_response :success
  end

  test "should update machine_type" do
    patch :update, id: @machine_type, machine_type: { description: @machine_type.description, nr: @machine_type.nr }
    assert_redirected_to machine_type_path(assigns(:machine_type))
  end

  test "should destroy machine_type" do
    assert_difference('MachineType.count', -1) do
      delete :destroy, id: @machine_type
    end

    assert_redirected_to machine_types_path
  end
end

require 'test_helper'

class ResourceGroupMachinesControllerTest < ActionController::TestCase
  setup do
    @resource_group_machine = resource_group_machines(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:resource_group_machines)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create resource_group_machine" do
    assert_difference('ResourceGroupMachine.count') do
      post :create, resource_group_machine: { description: @resource_group_machine.description, name: @resource_group_machine.name, nr: @resource_group_machine.nr, type: @resource_group_machine.type }
    end

    assert_redirected_to resource_group_machine_path(assigns(:resource_group_machine))
  end

  test "should show resource_group_machine" do
    get :show, id: @resource_group_machine
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @resource_group_machine
    assert_response :success
  end

  test "should update resource_group_machine" do
    patch :update, id: @resource_group_machine, resource_group_machine: { description: @resource_group_machine.description, name: @resource_group_machine.name, nr: @resource_group_machine.nr, type: @resource_group_machine.type }
    assert_redirected_to resource_group_machine_path(assigns(:resource_group_machine))
  end

  test "should destroy resource_group_machine" do
    assert_difference('ResourceGroupMachine.count', -1) do
      delete :destroy, id: @resource_group_machine
    end

    assert_redirected_to resource_group_machines_path
  end
end

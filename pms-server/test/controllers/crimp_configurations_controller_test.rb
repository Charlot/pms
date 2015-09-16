require 'test_helper'

class CrimpConfigurationsControllerTest < ActionController::TestCase
  setup do
    @crimp_configuration = crimp_configurations(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:crimp_configurations)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create crimp_configuration" do
    assert_difference('CrimpConfiguration.count') do
      post :create, crimp_configuration: { cross_section: @crimp_configuration.cross_section, custom_id: @crimp_configuration.custom_id, part_id: @crimp_configuration.part_id, wire_group_name: @crimp_configuration.wire_group_name, wire_type: @crimp_configuration.wire_type }
    end

    assert_redirected_to crimp_configuration_path(assigns(:crimp_configuration))
  end

  test "should show crimp_configuration" do
    get :show, id: @crimp_configuration
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @crimp_configuration
    assert_response :success
  end

  test "should update crimp_configuration" do
    patch :update, id: @crimp_configuration, crimp_configuration: { cross_section: @crimp_configuration.cross_section, custom_id: @crimp_configuration.custom_id, part_id: @crimp_configuration.part_id, wire_group_name: @crimp_configuration.wire_group_name, wire_type: @crimp_configuration.wire_type }
    assert_redirected_to crimp_configuration_path(assigns(:crimp_configuration))
  end

  test "should destroy crimp_configuration" do
    assert_difference('CrimpConfiguration.count', -1) do
      delete :destroy, id: @crimp_configuration
    end

    assert_redirected_to crimp_configurations_path
  end
end

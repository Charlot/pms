require 'test_helper'

class MachineTimeRulesControllerTest < ActionController::TestCase
  setup do
    @machine_time_rule = machine_time_rules(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:machine_time_rules)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create machine_time_rule" do
    assert_difference('MachineTimeRule.count') do
      post :create, machine_time_rule: { length: @machine_time_rule.length, machine_type_id: @machine_time_rule.machine_type_id, oee_code_id: @machine_time_rule.oee_code_id, time: @machine_time_rule.time }
    end

    assert_redirected_to machine_time_rule_path(assigns(:machine_time_rule))
  end

  test "should show machine_time_rule" do
    get :show, id: @machine_time_rule
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @machine_time_rule
    assert_response :success
  end

  test "should update machine_time_rule" do
    patch :update, id: @machine_time_rule, machine_time_rule: { length: @machine_time_rule.length, machine_type_id: @machine_time_rule.machine_type_id, oee_code_id: @machine_time_rule.oee_code_id, time: @machine_time_rule.time }
    assert_redirected_to machine_time_rule_path(assigns(:machine_time_rule))
  end

  test "should destroy machine_time_rule" do
    assert_difference('MachineTimeRule.count', -1) do
      delete :destroy, id: @machine_time_rule
    end

    assert_redirected_to machine_time_rules_path
  end
end

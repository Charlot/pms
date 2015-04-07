require 'test_helper'

class MachineCombinationsControllerTest < ActionController::TestCase
  setup do
    @machine_combination = machine_combinations(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:machine_combinations)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create machine_combination" do
    assert_difference('MachineCombination.count') do
      post :create, machine_combination: { machine_id: @machine_combination.machine_id, s1: @machine_combination.s1, s2: @machine_combination.s2, s3: @machine_combination.s3, s4: @machine_combination.s4, t1: @machine_combination.t1, t2: @machine_combination.t2, t3: @machine_combination.t3, t4: @machine_combination.t4, w1: @machine_combination.w1, w2: @machine_combination.w2, wd1: @machine_combination.wd1, wd2: @machine_combination.wd2 }
    end

    assert_redirected_to machine_combination_path(assigns(:machine_combination))
  end

  test "should show machine_combination" do
    get :show, id: @machine_combination
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @machine_combination
    assert_response :success
  end

  test "should update machine_combination" do
    patch :update, id: @machine_combination, machine_combination: { machine_id: @machine_combination.machine_id, s1: @machine_combination.s1, s2: @machine_combination.s2, s3: @machine_combination.s3, s4: @machine_combination.s4, t1: @machine_combination.t1, t2: @machine_combination.t2, t3: @machine_combination.t3, t4: @machine_combination.t4, w1: @machine_combination.w1, w2: @machine_combination.w2, wd1: @machine_combination.wd1, wd2: @machine_combination.wd2 }
    assert_redirected_to machine_combination_path(assigns(:machine_combination))
  end

  test "should destroy machine_combination" do
    assert_difference('MachineCombination.count', -1) do
      delete :destroy, id: @machine_combination
    end

    assert_redirected_to machine_combinations_path
  end
end

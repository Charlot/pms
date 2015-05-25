require 'test_helper'

class MachineScopesControllerTest < ActionController::TestCase
  setup do
    @machine_scope = machine_scopes(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:machine_scopes)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create machine_scope" do
    assert_difference('MachineScope.count') do
      post :create, machine_scope: { machine_id: @machine_scope.machine_id, s1: @machine_scope.s1, s2: @machine_scope.s2, s3: @machine_scope.s3, s4: @machine_scope.s4, t1: @machine_scope.t1, t2: @machine_scope.t2, t3: @machine_scope.t3, t4: @machine_scope.t4, w1: @machine_scope.w1, w2: @machine_scope.w2, wd1: @machine_scope.wd1, wd2: @machine_scope.wd2 }
    end

    assert_redirected_to machine_scope_path(assigns(:machine_scope))
  end

  test "should show machine_scope" do
    get :show, id: @machine_scope
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @machine_scope
    assert_response :success
  end

  test "should update machine_scope" do
    patch :update, id: @machine_scope, machine_scope: { machine_id: @machine_scope.machine_id, s1: @machine_scope.s1, s2: @machine_scope.s2, s3: @machine_scope.s3, s4: @machine_scope.s4, t1: @machine_scope.t1, t2: @machine_scope.t2, t3: @machine_scope.t3, t4: @machine_scope.t4, w1: @machine_scope.w1, w2: @machine_scope.w2, wd1: @machine_scope.wd1, wd2: @machine_scope.wd2 }
    assert_redirected_to machine_scope_path(assigns(:machine_scope))
  end

  test "should destroy machine_scope" do
    assert_difference('MachineScope.count', -1) do
      delete :destroy, id: @machine_scope
    end

    assert_redirected_to machine_scopes_path
  end
end

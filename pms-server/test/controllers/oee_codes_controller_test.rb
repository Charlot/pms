require 'test_helper'

class OeeCodesControllerTest < ActionController::TestCase
  setup do
    @oee_code = oee_codes(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:oee_codes)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create oee_code" do
    assert_difference('OeeCode.count') do
      post :create, oee_code: {  }
    end

    assert_redirected_to oee_code_path(assigns(:oee_code))
  end

  test "should show oee_code" do
    get :show, id: @oee_code
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @oee_code
    assert_response :success
  end

  test "should update oee_code" do
    patch :update, id: @oee_code, oee_code: {  }
    assert_redirected_to oee_code_path(assigns(:oee_code))
  end

  test "should destroy oee_code" do
    assert_difference('OeeCode.count', -1) do
      delete :destroy, id: @oee_code
    end

    assert_redirected_to oee_codes_path
  end
end

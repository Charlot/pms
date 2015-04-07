require 'test_helper'

class CustomValuesControllerTest < ActionController::TestCase
  setup do
    @custom_value = custom_values(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:custom_values)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create custom_value" do
    assert_difference('CustomValue.count') do
      post :create, custom_value: { custom_field_id: @custom_value.custom_field_id, customized_id: @custom_value.customized_id, customized_type: @custom_value.customized_type, value: @custom_value.value }
    end

    assert_redirected_to custom_value_path(assigns(:custom_value))
  end

  test "should show custom_value" do
    get :show, id: @custom_value
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @custom_value
    assert_response :success
  end

  test "should update custom_value" do
    patch :update, id: @custom_value, custom_value: { custom_field_id: @custom_value.custom_field_id, customized_id: @custom_value.customized_id, customized_type: @custom_value.customized_type, value: @custom_value.value }
    assert_redirected_to custom_value_path(assigns(:custom_value))
  end

  test "should destroy custom_value" do
    assert_difference('CustomValue.count', -1) do
      delete :destroy, id: @custom_value
    end

    assert_redirected_to custom_values_path
  end
end

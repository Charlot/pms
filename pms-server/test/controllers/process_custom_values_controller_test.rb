require 'test_helper'

class ProcessCustomValuesControllerTest < ActionController::TestCase
  setup do
    @process_custom_value = process_custom_values(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:process_custom_values)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create process_custom_value" do
    assert_difference('ProcessCustomValue.count') do
      post :create, process_custom_value: { custom_field_id: @process_custom_value.custom_field_id, customized_id: @process_custom_value.customized_id, customized_type: @process_custom_value.customized_type, value: @process_custom_value.value }
    end

    assert_redirected_to process_custom_value_path(assigns(:process_custom_value))
  end

  test "should show process_custom_value" do
    get :show, id: @process_custom_value
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @process_custom_value
    assert_response :success
  end

  test "should update process_custom_value" do
    patch :update, id: @process_custom_value, process_custom_value: { custom_field_id: @process_custom_value.custom_field_id, customized_id: @process_custom_value.customized_id, customized_type: @process_custom_value.customized_type, value: @process_custom_value.value }
    assert_redirected_to process_custom_value_path(assigns(:process_custom_value))
  end

  test "should destroy process_custom_value" do
    assert_difference('ProcessCustomValue.count', -1) do
      delete :destroy, id: @process_custom_value
    end

    assert_redirected_to process_custom_values_path
  end
end

require 'test_helper'

class CustomFieldsControllerTest < ActionController::TestCase
  setup do
    @custom_field = custom_fields(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:custom_fields)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create custom_field" do
    assert_difference('CustomField.count') do
      post :create, custom_field: { default_value: @custom_field.default_value, description: @custom_field.description, editable: @custom_field.editable, field_format: @custom_field.field_format, format_store: @custom_field.format_store, is_filter: @custom_field.is_filter, is_for_all: @custom_field.is_for_all, is_query_value: @custom_field.is_query_value, is_required: @custom_field.is_required, max_length: @custom_field.max_length, min_length: @custom_field.min_length, multiple: @custom_field.multiple, name: @custom_field.name, position: @custom_field.position, possible_values: @custom_field.possible_values, regexp: @custom_field.regexp, searchable: @custom_field.searchable, type: @custom_field.type, validate_query: @custom_field.validate_query, value_query: @custom_field.value_query, visible: @custom_field.visible }
    end

    assert_redirected_to custom_field_path(assigns(:custom_field))
  end

  test "should show custom_field" do
    get :show, id: @custom_field
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @custom_field
    assert_response :success
  end

  test "should update custom_field" do
    patch :update, id: @custom_field, custom_field: { default_value: @custom_field.default_value, description: @custom_field.description, editable: @custom_field.editable, field_format: @custom_field.field_format, format_store: @custom_field.format_store, is_filter: @custom_field.is_filter, is_for_all: @custom_field.is_for_all, is_query_value: @custom_field.is_query_value, is_required: @custom_field.is_required, max_length: @custom_field.max_length, min_length: @custom_field.min_length, multiple: @custom_field.multiple, name: @custom_field.name, position: @custom_field.position, possible_values: @custom_field.possible_values, regexp: @custom_field.regexp, searchable: @custom_field.searchable, type: @custom_field.type, validate_query: @custom_field.validate_query, value_query: @custom_field.value_query, visible: @custom_field.visible }
    assert_redirected_to custom_field_path(assigns(:custom_field))
  end

  test "should destroy custom_field" do
    assert_difference('CustomField.count', -1) do
      delete :destroy, id: @custom_field
    end

    assert_redirected_to custom_fields_path
  end
end

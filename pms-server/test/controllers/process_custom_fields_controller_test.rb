require 'test_helper'

class ProcessCustomFieldsControllerTest < ActionController::TestCase
  setup do
    @process_custom_field = process_custom_fields(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:process_custom_fields)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create process_custom_field" do
    assert_difference('ProcessCustomField.count') do
      post :create, process_custom_field: { default_value: @process_custom_field.default_value, description: @process_custom_field.description, editable: @process_custom_field.editable, field_format: @process_custom_field.field_format, format_store: @process_custom_field.format_store, is_filter: @process_custom_field.is_filter, is_for_all: @process_custom_field.is_for_all, is_query_value: @process_custom_field.is_query_value, is_required: @process_custom_field.is_required, max_length: @process_custom_field.max_length, min_length: @process_custom_field.min_length, multiple: @process_custom_field.multiple, name: @process_custom_field.name, position: @process_custom_field.position, possible_values: @process_custom_field.possible_values, regexp: @process_custom_field.regexp, searchable: @process_custom_field.searchable, type: @process_custom_field.type, validate_query: @process_custom_field.validate_query, value_query: @process_custom_field.value_query, visible: @process_custom_field.visible }
    end

    assert_redirected_to process_custom_field_path(assigns(:process_custom_field))
  end

  test "should show process_custom_field" do
    get :show, id: @process_custom_field
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @process_custom_field
    assert_response :success
  end

  test "should update process_custom_field" do
    patch :update, id: @process_custom_field, process_custom_field: { default_value: @process_custom_field.default_value, description: @process_custom_field.description, editable: @process_custom_field.editable, field_format: @process_custom_field.field_format, format_store: @process_custom_field.format_store, is_filter: @process_custom_field.is_filter, is_for_all: @process_custom_field.is_for_all, is_query_value: @process_custom_field.is_query_value, is_required: @process_custom_field.is_required, max_length: @process_custom_field.max_length, min_length: @process_custom_field.min_length, multiple: @process_custom_field.multiple, name: @process_custom_field.name, position: @process_custom_field.position, possible_values: @process_custom_field.possible_values, regexp: @process_custom_field.regexp, searchable: @process_custom_field.searchable, type: @process_custom_field.type, validate_query: @process_custom_field.validate_query, value_query: @process_custom_field.value_query, visible: @process_custom_field.visible }
    assert_redirected_to process_custom_field_path(assigns(:process_custom_field))
  end

  test "should destroy process_custom_field" do
    assert_difference('ProcessCustomField.count', -1) do
      delete :destroy, id: @process_custom_field
    end

    assert_redirected_to process_custom_fields_path
  end
end

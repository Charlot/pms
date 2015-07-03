require 'test_helper'

class WarehouseRegexesControllerTest < ActionController::TestCase
  setup do
    @warehouse_regex = warehouse_regexes(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:warehouse_regexes)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create warehouse_regex" do
    assert_difference('WarehouseRegex.count') do
      post :create, warehouse_regex: { desc: @warehouse_regex.desc, regex: @warehouse_regex.regex, warehouse_nr: @warehouse_regex.warehouse_nr }
    end

    assert_redirected_to warehouse_regex_path(assigns(:warehouse_regex))
  end

  test "should show warehouse_regex" do
    get :show, id: @warehouse_regex
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @warehouse_regex
    assert_response :success
  end

  test "should update warehouse_regex" do
    patch :update, id: @warehouse_regex, warehouse_regex: { desc: @warehouse_regex.desc, regex: @warehouse_regex.regex, warehouse_nr: @warehouse_regex.warehouse_nr }
    assert_redirected_to warehouse_regex_path(assigns(:warehouse_regex))
  end

  test "should destroy warehouse_regex" do
    assert_difference('WarehouseRegex.count', -1) do
      delete :destroy, id: @warehouse_regex
    end

    assert_redirected_to warehouse_regexes_path
  end
end

require 'test_helper'

class NcrApiLogsControllerTest < ActionController::TestCase
  setup do
    @ncr_api_log = ncr_api_logs(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:ncr_api_logs)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create ncr_api_log" do
    assert_difference('NcrApiLog.count') do
      post :create, ncr_api_log: { log_type: @ncr_api_log.log_type, machine_nr: @ncr_api_log.machine_nr, order_item_nr: @ncr_api_log.order_item_nr, order_item_qty: @ncr_api_log.order_item_qty, order_item_state: @ncr_api_log.order_item_state, params_detail: @ncr_api_log.params_detail, return_detail: @ncr_api_log.return_detail }
    end

    assert_redirected_to ncr_api_log_path(assigns(:ncr_api_log))
  end

  test "should show ncr_api_log" do
    get :show, id: @ncr_api_log
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @ncr_api_log
    assert_response :success
  end

  test "should update ncr_api_log" do
    patch :update, id: @ncr_api_log, ncr_api_log: { log_type: @ncr_api_log.log_type, machine_nr: @ncr_api_log.machine_nr, order_item_nr: @ncr_api_log.order_item_nr, order_item_qty: @ncr_api_log.order_item_qty, order_item_state: @ncr_api_log.order_item_state, params_detail: @ncr_api_log.params_detail, return_detail: @ncr_api_log.return_detail }
    assert_redirected_to ncr_api_log_path(assigns(:ncr_api_log))
  end

  test "should destroy ncr_api_log" do
    assert_difference('NcrApiLog.count', -1) do
      delete :destroy, id: @ncr_api_log
    end

    assert_redirected_to ncr_api_logs_path
  end
end

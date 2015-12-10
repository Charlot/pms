require 'test_helper'

class AutoScrapRecordsControllerTest < ActionController::TestCase
  setup do
    @auto_scrap_record = auto_scrap_records(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:auto_scrap_records)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create auto_scrap_record" do
    assert_difference('AutoScrapRecord.count') do
      post :create, auto_scrap_record: { kanban_nr: @auto_scrap_record.kanban_nr, machine_nr: @auto_scrap_record.machine_nr, order_nr: @auto_scrap_record.order_nr, part_nr: @auto_scrap_record.part_nr, qty: @auto_scrap_record.qty, user_id: @auto_scrap_record.user_id }
    end

    assert_redirected_to auto_scrap_record_path(assigns(:auto_scrap_record))
  end

  test "should show auto_scrap_record" do
    get :show, id: @auto_scrap_record
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @auto_scrap_record
    assert_response :success
  end

  test "should update auto_scrap_record" do
    patch :update, id: @auto_scrap_record, auto_scrap_record: { kanban_nr: @auto_scrap_record.kanban_nr, machine_nr: @auto_scrap_record.machine_nr, order_nr: @auto_scrap_record.order_nr, part_nr: @auto_scrap_record.part_nr, qty: @auto_scrap_record.qty, user_id: @auto_scrap_record.user_id }
    assert_redirected_to auto_scrap_record_path(assigns(:auto_scrap_record))
  end

  test "should destroy auto_scrap_record" do
    assert_difference('AutoScrapRecord.count', -1) do
      delete :destroy, id: @auto_scrap_record
    end

    assert_redirected_to auto_scrap_records_path
  end
end

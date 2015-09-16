require 'test_helper'

class MeasuredValueRecordsControllerTest < ActionController::TestCase
  setup do
    @measured_value_record = measured_value_records(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:measured_value_records)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create measured_value_record" do
    assert_difference('MeasuredValueRecord.count') do
      post :create, measured_value_record: { crimp_height_1: @measured_value_record.crimp_height_1, crimp_height_2: @measured_value_record.crimp_height_2, crimp_height_3: @measured_value_record.crimp_height_3, crimp_height_4: @measured_value_record.crimp_height_4, crimp_height_5: @measured_value_record.crimp_height_5, crimp_width: @measured_value_record.crimp_width, i_crimp_heigth: @measured_value_record.i_crimp_heigth, i_crimp_width: @measured_value_record.i_crimp_width, note: @measured_value_record.note, production_order_id: @measured_value_record.production_order_id, pulloff_value: @measured_value_record.pulloff_value }
    end

    assert_redirected_to measured_value_record_path(assigns(:measured_value_record))
  end

  test "should show measured_value_record" do
    get :show, id: @measured_value_record
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @measured_value_record
    assert_response :success
  end

  test "should update measured_value_record" do
    patch :update, id: @measured_value_record, measured_value_record: { crimp_height_1: @measured_value_record.crimp_height_1, crimp_height_2: @measured_value_record.crimp_height_2, crimp_height_3: @measured_value_record.crimp_height_3, crimp_height_4: @measured_value_record.crimp_height_4, crimp_height_5: @measured_value_record.crimp_height_5, crimp_width: @measured_value_record.crimp_width, i_crimp_heigth: @measured_value_record.i_crimp_heigth, i_crimp_width: @measured_value_record.i_crimp_width, note: @measured_value_record.note, production_order_id: @measured_value_record.production_order_id, pulloff_value: @measured_value_record.pulloff_value }
    assert_redirected_to measured_value_record_path(assigns(:measured_value_record))
  end

  test "should destroy measured_value_record" do
    assert_difference('MeasuredValueRecord.count', -1) do
      delete :destroy, id: @measured_value_record
    end

    assert_redirected_to measured_value_records_path
  end
end

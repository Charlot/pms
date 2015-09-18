require 'test_helper'

class CustomDetailsControllerTest < ActionController::TestCase
  setup do
    @custom_detail = custom_details(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:custom_details)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create custom_detail" do
    assert_difference('CustomDetail.count') do
      post :create, custom_detail: { custom_nr: @custom_detail.custom_nr, part_nr_from: @custom_detail.part_nr_from, part_nr_to: @custom_detail.part_nr_to }
    end

    assert_redirected_to custom_detail_path(assigns(:custom_detail))
  end

  test "should show custom_detail" do
    get :show, id: @custom_detail
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @custom_detail
    assert_response :success
  end

  test "should update custom_detail" do
    patch :update, id: @custom_detail, custom_detail: { custom_nr: @custom_detail.custom_nr, part_nr_from: @custom_detail.part_nr_from, part_nr_to: @custom_detail.part_nr_to }
    assert_redirected_to custom_detail_path(assigns(:custom_detail))
  end

  test "should destroy custom_detail" do
    assert_difference('CustomDetail.count', -1) do
      delete :destroy, id: @custom_detail
    end

    assert_redirected_to custom_details_path
  end
end

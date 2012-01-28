require 'test_helper'

class SchoolyearsControllerTest < ActionController::TestCase
  setup do
    @schoolyear = schoolyears(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:schoolyears)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create schoolyear" do
    assert_difference('Schoolyear.count') do
      post :create, schoolyear: @schoolyear.attributes
    end

    assert_redirected_to schoolyear_path(assigns(:schoolyear))
  end

  test "should show schoolyear" do
    get :show, id: @schoolyear.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @schoolyear.to_param
    assert_response :success
  end

  test "should update schoolyear" do
    put :update, id: @schoolyear.to_param, schoolyear: @schoolyear.attributes
    assert_redirected_to schoolyear_path(assigns(:schoolyear))
  end

  test "should destroy schoolyear" do
    assert_difference('Schoolyear.count', -1) do
      delete :destroy, id: @schoolyear.to_param
    end

    assert_redirected_to schoolyears_path
  end
end

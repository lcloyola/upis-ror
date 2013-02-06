require 'test_helper'

class GwasControllerTest < ActionController::TestCase
  setup do
    @gwa = gwas(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:gwas)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create gwa" do
    assert_difference('Gwa.count') do
      post :create, gwa: @gwa.attributes
    end

    assert_redirected_to gwa_path(assigns(:gwa))
  end

  test "should show gwa" do
    get :show, id: @gwa.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @gwa.to_param
    assert_response :success
  end

  test "should update gwa" do
    put :update, id: @gwa.to_param, gwa: @gwa.attributes
    assert_redirected_to gwa_path(assigns(:gwa))
  end

  test "should destroy gwa" do
    assert_difference('Gwa.count', -1) do
      delete :destroy, id: @gwa.to_param
    end

    assert_redirected_to gwas_path
  end
end

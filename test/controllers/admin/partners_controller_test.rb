require 'test_helper'

class Admin::PartnersControllerTest < ActionController::TestCase
  setup do
    @admin_partner = admin_partners(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:admin_partners)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create admin_partner" do
    assert_difference('Admin::Partner.count') do
      post :create, admin_partner: {  }
    end

    assert_redirected_to admin_partner_path(assigns(:admin_partner))
  end

  test "should show admin_partner" do
    get :show, id: @admin_partner
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @admin_partner
    assert_response :success
  end

  test "should update admin_partner" do
    patch :update, id: @admin_partner, admin_partner: {  }
    assert_redirected_to admin_partner_path(assigns(:admin_partner))
  end

  test "should destroy admin_partner" do
    assert_difference('Admin::Partner.count', -1) do
      delete :destroy, id: @admin_partner
    end

    assert_redirected_to admin_partners_path
  end
end

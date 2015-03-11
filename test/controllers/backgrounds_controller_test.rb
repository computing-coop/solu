require 'test_helper'

class BackgroundsControllerTest < ActionController::TestCase
  setup do
    @background = backgrounds(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:backgrounds)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create background" do
    assert_difference('Background.count') do
      post :create, background: { active: @background.active, mobile: @background.mobile, mobile_content_type: @background.mobile_content_type, mobile_height: @background.mobile_height, mobile_size: @background.mobile_size, mobile_width: @background.mobile_width, regular: @background.regular, regular_content_type: @background.regular_content_type, regular_height: @background.regular_height, regular_size: @background.regular_size, regular_width: @background.regular_width }
    end

    assert_redirected_to background_path(assigns(:background))
  end

  test "should show background" do
    get :show, id: @background
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @background
    assert_response :success
  end

  test "should update background" do
    patch :update, id: @background, background: { active: @background.active, mobile: @background.mobile, mobile_content_type: @background.mobile_content_type, mobile_height: @background.mobile_height, mobile_size: @background.mobile_size, mobile_width: @background.mobile_width, regular: @background.regular, regular_content_type: @background.regular_content_type, regular_height: @background.regular_height, regular_size: @background.regular_size, regular_width: @background.regular_width }
    assert_redirected_to background_path(assigns(:background))
  end

  test "should destroy background" do
    assert_difference('Background.count', -1) do
      delete :destroy, id: @background
    end

    assert_redirected_to backgrounds_path
  end
end

require 'test_helper'

class DevotionalsControllerTest < ActionController::TestCase
  setup do
    @devotional = devotionals(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:devotionals)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create devotional" do
    assert_difference('Devotional.count') do
      post :create, devotional: { day: @devotional.day, passage: @devotional.passage, passage_mem: @devotional.passage_mem, passage_text: @devotional.passage_text, questions: @devotional.questions, quote: @devotional.quote, story: @devotional.story, title: @devotional.title }
    end

    assert_redirected_to devotional_path(assigns(:devotional))
  end

  test "should show devotional" do
    get :show, id: @devotional
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @devotional
    assert_response :success
  end

  test "should update devotional" do
    patch :update, id: @devotional, devotional: { day: @devotional.day, passage: @devotional.passage, passage_mem: @devotional.passage_mem, passage_text: @devotional.passage_text, questions: @devotional.questions, quote: @devotional.quote, story: @devotional.story, title: @devotional.title }
    assert_redirected_to devotional_path(assigns(:devotional))
  end

  test "should destroy devotional" do
    assert_difference('Devotional.count', -1) do
      delete :destroy, id: @devotional
    end

    assert_redirected_to devotionals_path
  end
end

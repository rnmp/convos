require 'test_helper'

class ConvosControllerTest < ActionController::TestCase
  setup do
    @convo = convos(:one)
    @user = users(:one)
    @topic = topics(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:convos)
  end

  test "should create convo" do
    assert_difference('Convo.count') do
      post :create, convo: { author: @convo.author, topic: topics(:one), user: users(:one), convo: @convo.convo, votes: @convo.votes }
    end

    assert_redirected_to convo_path(assigns(:convo)).with({partial:'comments/form', locals: { submit_text: 'submit'}})
  end

  test "should show convo" do
    get :show, id: @convo
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @convo
    assert_response :success
  end

  test "should update convo" do
    patch :update, id: @convo, convo: { author: @convo.author, url: @convo.convo, votes: @convo.votes }
    assert_redirected_to convo_path(assigns(:convo))
  end

  test "should destroy convo" do
    assert_difference('Convo.count', -1) do
      delete :destroy, id: @convo
    end

    assert_redirected_to convos_path
  end
end

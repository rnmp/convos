require 'test_helper'

class CommentsControllerTest < ActionController::TestCase
  setup do
    @comment = comments(:one)
    @request.env["HTTP_REFERER"] = 'http://convos.org/'
  end

  test "should create comment" do
    assert_difference('Comment.count') do
      post :create, comment: { author: @comment.author, comment: @comment.comment, votes: @comment.votes }
    end

    assert_redirected_to comment_path(assigns(:comment))
  end

  test "should get edit" do
    get :edit, id: @comment
    assert_response :success
  end

  test "should update comment" do
    patch :update, id: @comment, comment: { author: @comment.author, comment: @comment.comment, votes: @comment.votes }
    assert_redirected_to comment_path(assigns(:comment))
  end

  test "should destroy comment" do
    assert_difference('Comment.count', -1) do
      delete :destroy, id: @comment
    end

    assert_redirected_to comments_path
  end
end

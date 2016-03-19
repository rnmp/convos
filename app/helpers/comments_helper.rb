module CommentsHelper
  def comments_tree_for(comments, sort_by_attribute)
    comments.sort_by{|k, v| k[sort_by_attribute] }.reverse.map do |comment, nested_comments|
      render(comment) + 
      content_tag(:div, 
      	render(partial: 'comments/form', locals: { comment: Comment.new(parent_id: comment.id, convo_id: comment.convo.id), submit_text: 'reply', placeholder: 'reply to comment...', form_id: "reply_to_#{comment.id}" }) + 
      	(nested_comments.size > 0 ? comments_tree_for(nested_comments, sort_by_attribute) : nil), 
      	class: "replies")
    end.join.html_safe
  end
end

module CommentsHelper
  def comments_tree_for(comments, sort_by_attribute)
	  comments.sort_by{|k, v| k[sort_by_attribute] }.reverse.map do |comment, nested_comments|
	    render(comment) +
	      (nested_comments.size > 0 ? content_tag(:div, comments_tree_for(nested_comments, sort_by_attribute), class: "replies") : nil)
	  end.join.html_safe
  end
end

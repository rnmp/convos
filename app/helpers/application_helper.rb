module ApplicationHelper
  def markdown(text)
    options = {
      filter_html:     true,
      hard_wrap:       true, 
      link_attributes: { rel: 'nofollow', target: "_blank" },
      space_after_headers: true, 
      fenced_code_blocks: true
    }

    extensions = {
      autolink:           true,
      superscript:        true,
      disable_indented_code_blocks: true
    }

    renderer = Redcarpet::Render::HTML.new(options)
    markdown = Redcarpet::Markdown.new(renderer, extensions)

    markdown.render(text).html_safe
  end

  def topics_list 
    topics = Topic.all
  end

  def pluralized_points_for(item)
    ['<span data-item-type="',item.class.to_s.downcase,'" data-item-id="', item.id,'">', item.plusminus,'</span>',' point'.pluralize(item.plusminus)].join('').html_safe
  end

  def pluralized_comments_for(convo)
    convo.comments.count.to_s + ' comment'.pluralize(convo.comments.count)
  end

  def comments_tree_for(comments)
	  comments.map do |comment, nested_comments|
	    render(comment) +
	      (nested_comments.size > 0 ? content_tag(:div, comments_tree_for(nested_comments), class: "replies") : nil)
	  end.join.html_safe
  end
end
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

  def cp(path)
    "active" if current_page?(path)
  end

  def pluralized_points_for(item)
    ['<span class=points-count>', item.points,'</span>','<span class=points-noun>',' point'.pluralize(item.points),'</span>'].join('').html_safe
  end

  def pluralized_comments_for(convo)
    convo.comments.count.to_s + ' comment'.pluralize(convo.comments.count)
  end
end

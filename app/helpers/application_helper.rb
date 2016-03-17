module ApplicationHelper
  def markdown(text)
    options = {
      filter_html:     true,
      hard_wrap:       true, 
      link_attributes: { rel: 'nofollow', target: "_blank" },
      with_toc_data: true
    }

    extensions = {
      autolink:           true,
      superscript:        true,
      space_after_headers: true, 
      disable_indented_code_blocks: false,
      fenced_code_blocks: false,
      tables: true,
      no_intra_emphasis: true,
      strikethrough: true
    }

    renderer = Redcarpet::Render::HTML.new(options)
    markdown = Redcarpet::Markdown.new(renderer, extensions)

    markdown.render(text).html_safe
  end

  def markdown_for_title(text)
    markdown(text).to_s.gsub!(/<[^>]*>/, "")
  end

  def cp(path)
    "active" if current_page?(path)
  end

  def pluralized_points_for(item)
    ['<span data-item-type="',item.class.to_s.downcase,'" data-item-id="', item.id,'">', item.points,'</span>',' point'.pluralize(item.points)].join('').html_safe
  end

  def pluralized_comments_for(convo)
    convo.comments.count.to_s + ' comment'.pluralize(convo.comments.count)
  end
end

module ApplicationHelper
  require './lib/helpers/convos_markdown_renderer'
  def markdown(content, user)
    options = {
      filter_html:     true,
      hard_wrap:       true, 
      link_attributes: { rel: 'nofollow', target: "_blank" },
      with_toc_data: true,
      current_user: user # HACK for Polls (issue-40)
    }

    extensions = {
      autolink: true,
      superscript: true,
      space_after_headers: false, 
      disable_indented_code_blocks: false,
      fenced_code_blocks: false,
      tables: true,
      no_intra_emphasis: true,
      strikethrough: true
    }

    @renderer = ConvosMarkdownRenderer.new(options)
    @markdown ||= Redcarpet::Markdown.new(@renderer, extensions)

    @markdown.render(content).html_safe
  end

  def markdown_content_for(content, user)
    content_tag(:div, markdown(content, user), class: 'user-content')
  end

  def cp(path)
    "active" if current_page?(path)
  end

  def errors_for(form, attribute, name)
    content_tag(:p, "#{name} #{form.object.errors[attribute].join(" and ")}.", class: 'error') if form.object.errors[attribute].any?
  end

  def pluralized_points_for(item)
    ['<span class="point-count">', item.points,'</span>','<span class="point-word">',' point'.pluralize(item.points),'</span>'].join('').html_safe
  end

  def pluralized_comments_for(convo)
    convo.comments.count.to_s + ' comment'.pluralize(convo.comments.count)
  end
end

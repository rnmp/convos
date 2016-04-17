module ApplicationHelper
  class ConvosRenderer < Redcarpet::Render::HTML
    def autolink(link, link_type)
      case link_type
        when :url then url_link(link)
        when :email then email_link(link)
      end
    end
    def url_link(link)
      case link
        when /https?:\/\/(www\.)?youtube\.com\// then youtube_link(link)
        when /https?:\/\/(www\.)?vimeo\.com\// then vimeo_link(link)
        when /(png|gif|jpg|jpeg)/ then image_link(link)
        else normal_link(link)
      end
    end
    def multimedia_link(html_class, link, type)
      "<span class='#{html_class} multimedia'>"+
        "<a class='embed-link' href='javascript:;'>show #{type}</a> "+normal_link(link)+
      "</span>"
    end
    def youtube_link(link)
      multimedia_link('youtube', link, 'video')
    end
    def vimeo_link(link)
      multimedia_link('vimeo', link, 'video')
    end
    def image_link(link)
      multimedia_link('image', link, 'image')
    end
    def image(link, title, alt_text)
      multimedia_link('image', link, 'image')
    end
    def normal_link(link)
      "<a href='#{link}' target='_blank' rel='nofollow'>#{link}</a>"
    end
    def email_link(email)
      "<a href=\"mailto:#{email}\">#{email}</a>"
    end
  end

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
      space_after_headers: false, 
      disable_indented_code_blocks: false,
      fenced_code_blocks: false,
      tables: true,
      no_intra_emphasis: true,
      strikethrough: true
    }

    renderer = ConvosRenderer.new(options)
    markdown = Redcarpet::Markdown.new(renderer, extensions)

    markdown.render(text).html_safe
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

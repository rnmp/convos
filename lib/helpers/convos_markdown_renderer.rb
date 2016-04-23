require 'render_anywhere'
class ConvosMarkdownRenderer < Redcarpet::Render::HTML
  VALID_YOUTUBE_URL = /https?:\/\/(?:www\.)?youtube.com\/watch\?(?=.*v=\w+)(?:\S+)?/
  VALID_VIMEO_URL = /https?:\/\/(?:www\.|player\.)?vimeo.com\/(?:channels\/(?:\w+\/)?|groups\/([^\/]*)\/videos\/|album\/(\d+)\/video\/|video\/|)(\d+)(?:$|\/|\?)/
  VALID_DIRECT_IMAGE_URL = /\.(png|gif|jpg|jpeg)$/

  include Redcarpet::Render::SmartyPants
  include RenderAnywhere

  def initialize(options)
    super
    # HACK
    @user = options[:current_user]
  end

  class RenderingController < RenderAnywhere::RenderingController
    # include custom modules here, define accessors, etc. For example:
    attr_accessor :current_user
    helper_method :current_user
  end

  def rendering_controller
    @rendering_controller ||= self.class.const_get("RenderingController").new
  end

  def autolink(link, link_type)
    case link_type
      when :url then url_link(link, link)
      when :email then email_link(link)
    end
  end

  def link(link, title, content)
    url_link(link, content)
  end

  def image(link, title, alt_text)
    multimedia_link(link, :image, "<img src='#{link}' title='#{title}' alt='#{alt_text}' />", link)
  end

  # For future reference:
  # def postprocess(full_document)
  #   full_document.gsub!(':trump:', 'THEY RAPISTS!')
  #   full_document
  # end

  def postprocess(full_document)
    rendering_controller.current_user = @user

    full_document.gsub!(/\(poll:(\d+)\)/) do |poll_match| 
      poll_id = /\d+/.match(poll_match)[0].to_i
      @poll = Poll.find(poll_id)
      render @poll
    end
    full_document
  end

  private 
    # custom methods
    def url_link(link, content)
      case link
        when VALID_YOUTUBE_URL then youtube_link(link, content)
        when VALID_VIMEO_URL then vimeo_link(link, content)
        when VALID_DIRECT_IMAGE_URL then image_link(link, content)
        else normal_link(link, content)
      end
    end

    def multimedia_link(link, type, embed_code, content)
      "<span class='multimedia'>" + 
        "#{normal_link(link, content)} <a class='embed-link' href='javascript:;'>show #{type}</a>" +
        "<span class='embed-code'>#{embed_code}</span>" +
      "</span>"
    end

    def video_embed_code(url)
      "<iframe width='640' height='360' src='#{url}' frameborder='0' allowfullscreen='allowfullscreen'></iframe>"
    end
    def youtube_link(link, content)
      multimedia_link(link, :video, video_embed_code("https://www.youtube.com/embed/#{link.split('v=').last.split('&').first}"), content)
    end
    def vimeo_link(link, content)
      multimedia_link(link, :video, video_embed_code("https://player.vimeo.com/video/#{VALID_VIMEO_URL.match(link)[3]}?portrait=0"), content)
    end

    def image_link(link, content)
      multimedia_link(link, :image, "<img src='#{link}' alt />", content)
    end

    def normal_link(link, content)
      "<a href='#{link}' target='_blank' rel='nofollow'>#{content}</a>"
    end
    def email_link(email)
      "<a href=\"mailto:#{email}\">#{email}</a>"
    end
end

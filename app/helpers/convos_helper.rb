module ConvosHelper
  def host_for(url)
    @host = URI.parse(url).host
    @host.slice!('www.')
    @host
  end
  def render_thumbnail(url)
    @scrape = Scrape.find_by(url: url)
    if @scrape != nil
      link_to (image_tag @scrape.images.first), url, class: 'thumbnail'
    end
  end
end

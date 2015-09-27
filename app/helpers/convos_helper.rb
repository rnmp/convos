module ConvosHelper
  def host_for(url)
    @host = URI.parse(url).host
    @host.slice!('www.')
    @host
  end
  def render_thumbnail(convo)
    @scrape = Scrape.find(convo.scrape)
    link_to (image_tag @scrape.images.first), convo.url, class: 'thumbnail'
  end
end

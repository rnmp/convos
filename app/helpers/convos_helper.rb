module ConvosHelper
  def host_for(url)
    encoded_url = URI.encode(url)
    @host = URI.parse(encoded_url).host
    @host.slice!('www.')
    @host
  end
  def render_thumbnail(convo)
    @scrape = Scrape.find(convo.scrape)
    link_to (image_tag @scrape.images.first), convo.url, class: 'thumbnail'
  end
end

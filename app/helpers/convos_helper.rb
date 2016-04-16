module ConvosHelper
  def host_for(url)
    encoded_url = URI.encode(url)
    @host = URI.parse(encoded_url).host
    @host.slice!('www.')
    @host
  end
  def convo_url(convo, &options)
    convo_slug_path(convo.topic.slug, convo.id, convo.slug, &options)
  end
end

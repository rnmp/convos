module ConvosHelper
  def host_for(url)
    encoded_url = URI.encode(url)
    @host = URI.parse(encoded_url).host
    @host.slice!('www.')
    @host
  end
end

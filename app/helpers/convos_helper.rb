module ConvosHelper
  def host_for(url)
    @host = URI.parse(url).host
    @host.slice!('www.')
    @host
  end
end

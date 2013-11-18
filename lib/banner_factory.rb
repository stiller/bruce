class BannerFactory
  def self.build config
    if config.respond_to? :url
      config
    else
      Banner.new(config)
    end
  end
end

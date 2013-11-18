class BannerFactory
  def self.build config
    if config.respond_to? :url
      config
    else
      Selection.new(config)
    end
  end
end

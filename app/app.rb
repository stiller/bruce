module Bruce
  class App < Padrino::Application
    use ActiveRecord::ConnectionAdapters::ConnectionManagement
    register Padrino::Rendering
    register Padrino::Helpers
    require 'json'
    require 'pry'

    enable :sessions

    get "/" do
      banner_hash = $redis.fetch_for(request_key)
      previous_banner = BannerFactory.build(banner_hash)
      @banner = Frontend.new(banners).get_another_value_for(previous_banner)
      $redis.save_for(request_key, @banner)
      render :erb, "<img src='<%= @banner.url %>'>"
    end

    private

    def banners
      bannerlist = $redis.cache(settings.banners_key, settings.expire_time) do
        banners = Banner.all
        first_strategy = Strategies::Random.new(banners)
        second_strategy = Strategies::Weighted.new(banners)
        listgen = ListGenerator.new(first_strategy, second_strategy, 3,7)
        listgen.pick(15)
      end
      bannerlist.map {|banner| BannerFactory.build(banner) }
    end

    def request_key
      "#{request.ip}"
    end
  end
end

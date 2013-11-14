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
      @banner = BannerFactory.build(banner_hash)
      @banner = Frontend.new(banners).get_another_value_for(@banner)
      $redis.save_for(request_key, @banner)
      render :erb, "<img src='<%= @banner.url %>'>"
    end

    private

    def banners
      bannerlist = $redis.cache(banners_key,10) do
        banners = Banner.all
        first_strategy = Strategies::Random.new(banners)
        second_strategy = Strategies::Weighted.new(banners)
        listgen = ListGenerator.new(first_strategy, second_strategy, 3,7)
        listgen.pick(15)
      end
      bannerlist.map {|banner| BannerFactory.build(banner) }
    end

    def banners_key
      "banners"
    end

    def request_key
      "#{request.ip}"
    end

    def expire_time
      600
    end
  end
end

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
        campaign = Campaign.first
        banners = campaign.selections.enabled
        first_strategy  = strategy_class(campaign.strategy1).new(banners)
        second_strategy = strategy_class(campaign.strategy2).new(banners)
        listgen = ListGenerator.new(first_strategy, second_strategy, campaign.ratio1, campaign.ratio2)
        listgen.pick(15)
      end
      bannerlist.map {|banner| BannerFactory.build(banner) }
    end

    def strategy_class klass
      ("Strategies::" + klass.camelize).constantize
    end

    def request_key
      "#{request.ip}"
    end
  end
end

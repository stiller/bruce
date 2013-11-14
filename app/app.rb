module Bruce
  class App < Padrino::Application
    use ActiveRecord::ConnectionAdapters::ConnectionManagement
    register Padrino::Rendering
    register Padrino::Helpers
    require 'json'
    require 'pry'

    enable :sessions

    get "/" do
      bannerlist = $redis.cache(banners_key,10) do
        banners = Banner.all.map{|b| {b.url => b.weight}}.reduce(Hash.new, :merge)
        Strategies::ListGenerator.new(Strategies::RandomBanner.new(banners),
                                      Strategies::WeightedBanner.new(banners),
                                      3,7).pick(15)
      end
      @banner = $redis.fetch_for request_key
      @banner = Frontend.new(bannerlist).get_another_value_for(@banner)
      @banner = Banner.new(@banner) if @banner.kind_of? Hash
      $redis.save_for request_key, @banner
      render :erb, "<img src='<%= @banner.url %>'>"
    end

    private

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

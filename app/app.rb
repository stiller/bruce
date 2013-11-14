module Bruce
  class App < Padrino::Application
    use ActiveRecord::ConnectionAdapters::ConnectionManagement
    register Padrino::Rendering
    register Padrino::Helpers
    require 'json'
    require 'pry'

    enable :sessions


    get "/" do
      list = $redis.cache(redis_key,10) do
        banners = Banner.all.map{|b| {b.url => b.weight}}.reduce(Hash.new, :merge)
        list = Strategies::ListGenerator.new(Strategies::RandomBanner.new(banners),
               Strategies::WeightedBanner.new(banners),
               3,7).pick(15)
        list.to_json
      end
      list = JSON.parse(list)
      urls = list.map{ |banner| banner['name'] }
      @banner_url = fetch_banner_for request_key
      @banner_url = Frontend.new.get_another_value_for(@banner_url, urls)
      save_banner_for request_key, @banner_url
      render :erb, "<img src='<%= @banner_url %>'>"
    end

    private

    def redis_key
      "banners"
    end

    def request_key
      "#{request.ip}"
    end

    def expire_time
      600
    end

    def fetch_banner_for key
      $redis.get(key)
    end

    def save_banner_for key, banner
      $redis.set(key,banner)
      $redis.expire(key,expire_time)
    end
  end
end

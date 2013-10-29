  class App < Padrino::Application
    use ActiveRecord::ConnectionAdapters::ConnectionManagement
    register Padrino::Rendering
    register Padrino::Helpers
    require 'json'
    require 'pry'

    enable :sessions


    get "/" do
      @list = $redis.cache(redis_key,10) do
        banners = Banner.all.map{|b| {b.url => b.weight}}.reduce(Hash.new, :merge)
        list = Bruce::ListGenerator.new(Bruce::RandomBanner.new(banners),
               Bruce::WeightedBanner.new(banners),
               3,7).pick(15)
        list.to_json
      end
      @list = JSON.parse(@list)
      @list = @list.map{ |banner| Bruce::Banner.new(banner['name'],banner['weight']) }
      render :erb, "<img src='<%= @list.sample.name %>'>"
    end

    def redis_key
      "banners"
    end

  end

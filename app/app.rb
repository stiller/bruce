module Bruce
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
        list = Strategies::ListGenerator.new(Strategies::RandomBanner.new(banners),
               Strategies::WeightedBanner.new(banners),
               3,7).pick(15)
        list.to_json
      end
      @list = JSON.parse(@list)
      @urls = @list.map{ |banner| banner['name'] }
      @value = get_new_value_for("#{request.ip}", @urls)
      render :erb, "<img src='<%= @value %>'>"
    end

    def redis_key
      "banners"
    end

    def get_new_value_for key, collection
      new_value = collection.sample
      return new_value if single_unique_element_in collection

      if (previous_value = $redis.get(key))
        new_value = collection.reject{|element| element == previous_value}.sample
      end
      $redis.set(key,new_value)
      $redis.expire(key,600)
      new_value
    end

    def single_unique_element_in collection
      Set.new(collection).size < 2
    end
  end
end

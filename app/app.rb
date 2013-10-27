  class App < Padrino::Application
    use ActiveRecord::ConnectionAdapters::ConnectionManagement
    register Padrino::Rendering
    register Padrino::Helpers

    enable :sessions

    get "/" do
      # Ok, I did NOT think this through
      banners = Banner.all.map{|b| {b.url => b.weight}}.reduce(Hash.new, :merge)
      list = Bruce::ListGenerator.new(Bruce::RandomBanner.new(banners),
                                      Bruce::WeightedBanner.new(banners),3,7)
      list.pick(10).first.name
    end

  end

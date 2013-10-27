module Bruce
  class App < Padrino::Application
    use ActiveRecord::ConnectionAdapters::ConnectionManagement
    register Padrino::Rendering
    register Padrino::Helpers

    enable :sessions

    get "/" do
      "Hello World!"
    end

  end
end

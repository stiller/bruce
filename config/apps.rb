##
# This file mounts each app in the Padrino project to a specified sub-uri.
# You can mount additional applications using any of these commands below:
#
#   Padrino.mount('blog').to('/blog')
#   Padrino.mount('blog', :app_class => 'BlogApp').to('/blog')
#   Padrino.mount('blog', :app_file =>  'path/to/blog/app.rb').to('/blog')
#
# You can also map apps to a specified host:
#
#   Padrino.mount('Admin').host('admin.example.org')
#   Padrino.mount('WebSite').host(/.*\.?example.org/)
#   Padrino.mount('Foo').to('/foo').host('bar.example.org')
#
# Note 1: Mounted apps (by default) should be placed into the project root at '/app_name'.
# Note 2: If you use the host matching remember to respect the order of the rules.
#
# By default, this file mounts the primary app which was generated with this project.
# However, the mounted app can be modified as needed:
#
#   Padrino.mount('AppName', :app_file => 'path/to/file', :app_class => 'BlogApp').to('/')
#

##
# Setup global project settings for your apps. These settings are inherited by every subapp. You can
# override these settings in the subapps as needed.
#
Padrino.configure_apps do
  # enable :sessions
  set :session_secret, 'e9a8dd4c25c487706eba01e743e0a51827ee3367e24ed089d114b3aed9be6e87'
  set :protection, true
  set :protect_from_csrf, true
  set :banners_key, 'banners'
  set :expire_time, 10
  uri = URI.parse(ENV["REDISTOGO_URL"] || 'redis://localhost:6379')
  $redis = RedisClient.new(:host => uri.host, :port => uri.port, :password => uri.password)
end

# Mounts the core application for this project
Padrino.mount('Bruce::App', :app_file => Padrino.root('app/app.rb')).to('/')

Padrino.mount("Bruce::Admin", :app_file => File.expand_path('../../admin/app.rb', __FILE__)).to("/admin")

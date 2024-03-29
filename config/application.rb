require File.expand_path('../boot', __FILE__)

require 'rails/all'

Bundler.require(:default, Rails.env)

module TShirts
  class Application < Rails::Application
    config.autoload_paths += %W(#{ config.root }/lib/crawler #{ config.root }/app/workers)
    config.active_record.timestamped_migrations = false
  end
end

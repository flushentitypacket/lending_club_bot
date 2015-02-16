module Connection
  def connect
    require "sequel"
    env = ENV['LENDING_CLUB_BOT_ENV'] || 'development'
    require 'yaml'
    config = YAML.load_file('config/database.yml')[env.to_sym]
    Sequel.connect(config)
  end
end

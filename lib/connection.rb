module Connection
  def connect
    require "sequel"
    env = ENV['LENDING_CLUB_BOT_ENV'] || 'development'
    require 'yaml'
    db_config = YAML.load_file('config/database.yml')
    db_config = db_config[env] || db_config[env.to_sym] || db_config
    db_config.keys.each{|k| db_config[k.to_sym] = db_config.delete(k)}
    Sequel.connect(db_config)
  end
end

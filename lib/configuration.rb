require 'lending_club'
require 'strategy'
require 'yaml'

class Configuration
  DEFAULT_CREDENTIALS_PATH = 'config/credentials.yml'
  attr_reader :credentials_path
  def credentials_path=(path)
    @credentials_path = path
    load_credentials
  end
  def credentials
    YAML.load_file(credentials_path)
  end

  DEFAULT_DATABASE_PATH = 'config/database.yml'
  attr_accessor :database_path

  DEFAULT_STRATEGY = Strategy.new
  attr_accessor :strategy

  DEFAULT_NOTIFIER = nil
  attr_accessor :notifier

  DEFAULT_DRY_RUN = true
  attr_writer :dry_run
  def dry_run?
    !!@dry_run
  end

  def initialize
    @credentials_path = DEFAULT_CREDENTIALS_PATH
    @database_path = DEFAULT_DATABASE_PATH
    @strategy = DEFAULT_STRATEGY
    @notifier = DEFAULT_NOTIFIER
    @dry_run = DEFAULT_DRY_RUN
  end

end

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

  DEFAULT_DATABASE_PATH = 'config/database.yml'
  attr_accessor :database_path

  DEFAULT_STRATEGY = Strategy.new
  attr_accessor :strategy

  DEFAULT_NOTIFIER = nil
  attr_accessor :notifier

  def initialize
    @credentials_path = DEFAULT_CREDENTIALS_PATH
    load_credentials
    @database_path = DEFAULT_DATABASE_PATH
    @strategy = DEFAULT_STRATEGY
    @notifier = DEFAULT_NOTIFIER
  end

  def access_token=(token)
    LendingClub.access_token = token
  end

  def investor_id=(id)
    LendingClub.investor_id = id
  end

  private

  def load_credentials
    YAML.load_file(credentials_path).tap do |credentials|
      LendingClub.access_token = credentials['access_token']
      LendingClub.investor_id = credentials['investor_id']
    end
  end

end

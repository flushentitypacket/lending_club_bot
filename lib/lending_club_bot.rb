require 'lending_club'
require 'configuration'
require 'connection'
require 'models'
require 'order'

class LendingClubBot
  include Connection
  include Models
  attr_reader :configuration

  def initialize
    @configuration = Configuration.new
  end

  def run
    connect(db_config)
    require_models
    loans = LendingClub.loans
    loans_to_buy = configuration.strategy.call(loans)
    order = Order.new(loans_to_buy, dry_run: configuration.dry_run?)
    purchases = order.execute!
    configuration.notifier.notify(purchases) if configuration.notifier
    nil
  end

  def configure
    yield configuration
    self
  end

  def env
    ENV['LENDING_CLUB_BOT_ENV'] || 'development'
  end

  def db_config
    require 'yaml'
    YAML.load_file(configuration.database_path)[env.to_sym]
  end

end

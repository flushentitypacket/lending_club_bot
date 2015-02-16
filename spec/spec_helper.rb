require 'minitest/autorun'

require 'minitest/reporters'
reporter_options = { color: true }
Minitest::Reporters.use! [Minitest::Reporters::DefaultReporter.new(reporter_options)]

require 'connection'
include Connection
env = 'test'
require 'yaml'
config = YAML.load_file('config/database.yml')[env.to_sym]
connect(config)

require 'models'
include Models
require_models

require 'database_cleaner'
DatabaseCleaner.strategy = :transaction
require 'factory_girl'
class MiniTest::Spec
  include FactoryGirl::Syntax::Methods

  def before_suites
    FactoryGirl.lint
  end

  before :each do
    DatabaseCleaner.start
  end

  after :each do
    DatabaseCleaner.clean
  end
end
# Load factories
Dir[File.dirname(__FILE__) + '/factories/*_factory.rb'].each {|file| require file }

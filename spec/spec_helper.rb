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

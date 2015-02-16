$LOAD_PATH.unshift(File.expand_path(File.dirname(__FILE__)))
$LOAD_PATH.unshift(File.expand_path(File.join(File.dirname(__FILE__), 'lib')))

desc 'Starts a pry REPL with some files preloaded'
task :console do
  require 'lending_club'
  require 'lending_club_bot'
  require 'pry'
  include Models
  require_models
  ARGV.clear
  Pry.start
end

namespace :db do
  require "sequel"
  Sequel.extension :migration
  env = ENV['LENDING_CLUB_BOT_ENV'] || 'development'
  require 'yaml'
  db_config = YAML.load_file('config/database.yml')
  db_config = db_config[env] || db_config[env.to_sym] || db_config
  db_config.keys.each{|k| db_config[k.to_sym] = db_config.delete(k)}
  DB = Sequel.connect(db_config)

  desc "Prints current schema version"
  task :version do
    version = if DB.tables.include?(:schema_info)
      DB[:schema_info].first[:version]
    end || 0

    puts "Schema Version: #{version}"
  end

  desc "Perform migration up to latest migration available"
  task :migrate do
    Sequel::Migrator.run(DB, "lib/migrations")
    Rake::Task['db:version'].execute
  end

  desc "Perform rollback to specified target or full rollback as default"
  task :rollback, :target do |t, args|
    args.with_defaults(:target => 0)

    Sequel::Migrator.run(DB, "lib/migrations", :target => args[:target].to_i)
    Rake::Task['db:version'].execute
  end

  desc "Perform migration reset (full rollback and migration)"
  task :reset do
    Sequel::Migrator.run(DB, "lib/migrations", :target => 0)
    Sequel::Migrator.run(DB, "lib/migrations")
    Rake::Task['db:version'].execute
  end
end

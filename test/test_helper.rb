$:.unshift(File.dirname(__FILE__) + '/../lib')
rails_root = File.dirname(__FILE__) + '/../../../../'

require "#{rails_root}/config/environment.rb"
require "test_help"

config = YAML::load(IO.read(File.dirname(__FILE__) + '/database.yml'))
ActiveRecord::Base.logger = Logger.new(File.dirname(__FILE__) + "/debug.log")
ActiveRecord::Base.establish_connection(config[ENV['DB'] || 'sqlite3'])

load(File.dirname(__FILE__) + "/schema.rb") if File.exist?(File.dirname(__FILE__) + "/schema.rb")
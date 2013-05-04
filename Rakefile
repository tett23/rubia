require 'bundler/setup'
Bundler.require(:default)
require 'padrino-core/cli/rake'

PadrinoTasks.use(:database)
PadrinoTasks.use(:datamapper)

require './config/database'
Dir["./lib/*.rb"].each {|file| require file }
DataMapper.finalize

require './config/database'
Dir["./models/*.rb"].each {|file| require file }
DataMapper.finalize

PadrinoTasks.init

require 'rubygems'
require 'bundler/setup'
require 'sinatra'
require 'data_mapper'
require 'dm-core'
require 'dm-migrations'
require 'dm-sqlite-adapter'
require 'dm-timestamps'
require 'json'

require './models/User'
require './models/Goal'
require './models/Activity'
require './routes/auth'
require './routes/goal'
require './routes/dashboard'

configure do
    DataMapper::setup(:default, File.join('sqlite3://', Dir.pwd, 'development.db'))
end

configure do
  DataMapper.finalize
  DataMapper.auto_upgrade!
end

enable :sessions

get '/' do
  @user = User.get_logged_user(session)
  erb :index
end



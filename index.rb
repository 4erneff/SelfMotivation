require 'rubygems'
require 'bundler/setup'
require 'sinatra'
require 'data_mapper'
require 'dm-core'
require 'dm-migrations'
require 'dm-sqlite-adapter'
require 'dm-timestamps'

configure do
  DataMapper::setup(:default, File.join('sqlite3://', Dir.pwd, 'development.db'))
end

class User
  include DataMapper::Resource

  property :id, Serial
  property :name, String
  property :email, String
  property :password, String

  def initialize(hash_parameters)
    self.name = hash_parameters['name']
    self.password = hash_parameters['password']
  end

  def to_s
    "Username: #{name}, password: #{password}\n"
  end
end

configure do
  DataMapper.finalize
  DataMapper.auto_upgrade!
end

get '/' do
    @title = 'Dashboard'
    erb :index
end

get '/user/new' do
  @title = 'Registration'
  erb :register
end

get '/user/list' do
  @title = 'All users'
  @users = User.all(:order => [:name.desc])
  @users = @users.map { |user| user.to_s }
end

post '/user/create' do
  p params[:user]
  user = User.new(params[:user])
  if user.save
    @message = 'The registration was successful!'
  else
    @message = 'The registration failed!'
  end
end



require './helpers/EmailSender'
require 'digest'

class User
  include DataMapper::Resource

  property :id, Serial

  property :name, String,
    :required => true,
    :unique => true,
    :messages => {
      :presence => "Please enter username.",
      :is_unique => "This username already exist."
    }

  property :email, String,
    :required => true,
    :unique => true,
    :format => :email_address,
    :messages => {
      :presence => "Please enter your email address.",
      :is_unique => "This email address is already used.",
      :format => "This email address doesn't seem to be correct."
    }


  property :password, String,
    :required => true,
    :messages => {
      :presence => "Please enter password."
    }

  property :pass_code, String

  def initialize(hash_parameters)
    hash_parameters.each { |key, value| value.strip! }
    self.name = hash_parameters['name']
    unless hash_parameters['password'] == ""
      self.password = Digest::SHA256.base64digest hash_parameters['password']
    end
    self.email = hash_parameters['email']
    self.pass_code = (0...8).map { (65 + rand(26)).chr }.join
  end

  def to_s
    "Username: #{name}, password: #{password}, pass_code: #{pass_code}\n"
  end

  def self.authenticate(username, password)
    password = Digest::SHA256.base64digest password
    user = User.first(:name => username)
    p user
    return nil if user.nil? or password != user.password
    user
  end

  def self.password_forgotten(email)
    user = User.first(:email => email)
    user.update(:pass_code => user.id.to_s + (0...8).map { (65 + rand(26)).chr }.join)
    EmailSender.password_forgotten user.email, user.pass_code
  end

  def self.password_forgotten_change(key, password)
    password = Digest::SHA256.base64digest password
    user = User.first(:pass_code => key)
    user.update(:password => password)
  end

  def self.authenticated?(session)
    return session[:user] if session[:user] != nil
    redirect '/login'
  end
end

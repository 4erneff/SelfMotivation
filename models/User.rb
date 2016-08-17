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

  property :completed_goals, Integer,
    :default => 0


  def initialize(hash_parameters)
    hash_parameters.each { |key, value| value.strip! }
    self.name = hash_parameters['name']
    unless hash_parameters['password'] == ""
      self.password = Digest::SHA256.base64digest hash_parameters['password']
    end
    self.email = hash_parameters['email']
    self.pass_code = (0...8).map { (65 + rand(26)).chr }.join
    self.completed_goals = 0
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
    return nil unless user
    user.update(:pass_code => user.id.to_s + (0...8).map { (65 + rand(26)).chr }.join)
    EmailSender.password_forgotten user.email, user.pass_code
  end

  def self.password_forgotten_change(key, password)
    p key, password
    user = User.first(:pass_code => key)
    return nil if user == nil or password == nil or password.strip == ""
    password = Digest::SHA256.base64digest password
    user.update(:password => password)
  end

  def self.get_logged_user(session)
    return User.first(:id => session[:user]) if session[:user] != nil
    nil
  end
end

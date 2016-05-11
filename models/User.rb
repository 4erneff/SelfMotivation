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


  def initialize(hash_parameters)
    hash_parameters.each { |key, value| value.strip! }
    self.name = hash_parameters['name']
    self.password = hash_parameters['password']
    self.email = hash_parameters['email']
  end

  def to_s
    "Username: #{name}, password: #{password}\n"
  end

  def self.authenticate(username, password)
    p username, password
    user = User.first(:name => username)
    p user
    return nil if user.nil? or password != user.password
    user
  end
end

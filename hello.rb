require 'sinatra'
require 'active_record'

ActiveRecord::Base.establish_connection(
    :adapter => 'sqlite3',
      :database =>  'sinatra_application.sqlite3.db'
)

class User < ActiveRecord::Base
  has_many :user_urls, dependent: :destroy
  has_many :urls, through: :user_urls
end



get '/posts/:id' do
  @name = params[:id]
  User.create(name: @name, password: "123")
  erb :index
end


__END__

@@post
<p><%= @name %></p>

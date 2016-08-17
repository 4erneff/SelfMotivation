module Authentication
  def authenticate!
    unless session[:user]
      redirect '/login'
    end
  end
end

get '/user/new' do
  @title = 'Registration'
  erb :register
end

get '/user/list' do
  @title = 'All users'
  @users = User.all(:order => [:name.desc])
  @users = @users.map { |user| user.to_s + '\n' }
end

post '/user/create' do
  unless params[:user]['password'] == params[:user]['confirm_password']
    return { :status => 'error', :message => "The passwords don't match." }.to_json
  end
  user = User.new(params[:user])
  if user.save
    { :status => 'success', :message => 'The registration was successful!', :redirect => '/login' }.to_json
  else
    { :status => 'error', :message => user.errors.first() }.to_json
  end
end

get '/login' do
  @title = 'Login'
  erb :login
end

post '/login' do
  username = params[:username]
  password = params[:password]
  if user = User.authenticate(username, password)
    session[:user] = user.id
    { :status => 'success', :redirect => '/goal/list' }.to_json
  else
    { :status => 'error', :message => 'Wrong username or password' }.to_json
  end
end

get '/logout' do
  session[:user] = nil
  redirect '/baba'
end

get '/baba' do
  @title =  session[:user]
  erb :index
end

get '/password_forgotten' do
  @title = 'Password forgotten'
  erb :password_forgotten
end

post '/password_forgotten' do
  if User.password_forgotten params[:email]
    {:status => 'success', :message => 'Reset password link was sent to your email. You can use it to change your password'}.to_json
  else
    {:status => 'error', :message => 'There is no user with this email.'}.to_json
  end
end

get '/user/password/forgotten/change' do
  @key = params[:key]
  erb :password_forgotten_change
end

post '/user/password/forgotten/change' do
  user = User.password_forgotten_change params[:key], params[:new_password]
  if user
    {:status => 'success', 'message' => 'Your password has been changed!', :redirect => '/login'}.to_json
  else
    {:status => 'error', 'message' => 'Something went wrong. Please try again!'}.to_json
  end
end


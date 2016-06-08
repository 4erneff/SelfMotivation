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
    return "The two passwords don't match."
  end
  user = User.new(params[:user])
  if user.save
    @message = 'The registration was successful!'
  else
    @message = user.errors.first()
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
    redirect '/baba'
  else
    redirect 'succses'
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
  User.password_forgotten params[:email]
  redirect '/gjwp'
end

get '/user/password/forgotten/change' do
  @key = params[:key]
  erb :password_forgotten_change
end

post '/user/password/forgotten/change' do
  User.password_forgotten_change params[:key], params[:new_password]
  redirect '/login'
end

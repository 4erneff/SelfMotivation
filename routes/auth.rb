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
    redirect '/baba'
  else
    redirect 'succses'
  end
end

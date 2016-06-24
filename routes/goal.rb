get '/goal/new' do
  erb :create_goal
end

post '/goal/new' do
  p params
end

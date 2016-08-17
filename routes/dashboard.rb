get '/dash' do
  @users = User.all
  @users.sort! { |a, b| b.completed_goals <=> a.completed_goals }
  p @users
  erb :dashboard
end

get '/dash' do
  @user = User.get_logged_user session
  error 401 unless @user
  @users = User.all
  @users.sort! { |a, b| b.completed_goals <=> a.completed_goals }
  @stats = @user.get_stats
  p @users
  erb :dashboard
end

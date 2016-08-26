get '/goal/new' do
  @user = User.get_logged_user session
  error 401 unless @user
  erb :create_goal
end

post '/goal/new' do
  user = User.get_logged_user session
  error 401 unless user
  validation_result = Goal.validation params
  unless validation_result == "OK"
    return { :status => 'error', :message => validation_result }.to_json
  end

  goal = Goal.new(params, user)
  res = goal.save()
  metrics = params['metric']
  metrics.each do |key, value|
    metric = Metric.new(value, goal)
    metric.save()
    goal.metrics << metric
  end
  goal.save()
  p goal, res
  { :status => 'success', :message => 'Goal set successfully!', :redirect => 'list' }.to_json
end

get '/metric/list' do
  @metrics = Metric.all()
  @metrics = @metrics.map { |metric| metric.to_s }
end

get '/goal/list' do
  @user = User.get_logged_user session
  error 301 unless @user
  @goals_in_progress = Goal.all(:user => @user, :status => 'in_progress')
  @completed_goals = Goal.all(:user => @user, :status => 'completed')
  erb :goal_list
end

get '/goal/manage' do
  @user = User.get_logged_user session
  error 301 unless @user
  @goal = Goal.first(:id => params['g'])
  @statistic = Goal.statistic_chart @goal
  erb :goal_manage
end

get '/goal/manage/fetch_statistics' do
  goal = Goal.first(:id => params['g'])
  data = Goal.statistic_chart(goal).to_json
  data
end

post '/goal/manage/complete' do
  goal = Goal.first(:id => params['g'])
  unless goal.mark_as_completed()
    return {:status => 'error', :message => 'Something went wrong'}.to_json
  end
  {:status => 'success', :message => 'Well done! You have completed your goal'}.to_json
end

post '/goal/add-progress' do
  validation = Goal.add_progress_validation params
  unless validation == "OK"
    return { :status => 'error', :message => validation}.to_json
  end
  metrics = params['metric']
  metrics.each do |key, value|
    p = {}
    p['metric'] = Metric.first(:id => key)
    p['value'] = value
    p['date'] = params['date']
    Activity.track_activity p
  end
  { :status => 'success', :message => 'Progress added successfully'}.to_json
end

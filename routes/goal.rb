get '/goal/new' do
  user = User.get_logged_user session
  error 401 unless user
  p user
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
  goal.save()
  metrics = params['metric']
  metrics.each do |key, value|
    metric = Metric.new(value, goal)
    metric.save()
    goal.metrics << metric
  end
  goal.save()
  { :status => 'success', :message => 'Goal set successfully!', :redirect => 'list' }.to_json
end

get '/metric/list' do
  @metrics = Metric.all()
  @metrics = @metrics.map { |metric| metric.to_s }
end

get '/goal/list' do
  user = User.get_logged_user session
  error 301 unless user
  @goals = Goal.all(:user => user)
  erb :goal_list
end

get '/goal/manage' do
  @logged_user = User.get_logged_user session
  error 301 unless @logged_user
  @goal = Goal.first(:id => params['g'])
  p @goal
  @statistic = Goal.statistic_chart @goal
  p @statistic
  erb :goal_manage
end

get '/goal/manage/fetch_statistics' do
  goal = Goal.first(:id => params['g'])
  data = Goal.statistic_chart(goal).to_json
  p data
  data
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
  p Metric.all
  { :status => 'success', :message => 'Progress added successfully'}.to_json
end

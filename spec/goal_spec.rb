require File.expand_path '../spec_helper.rb', __FILE__

describe "Goal class" do
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  before(:context) do
    params = { 'name' => 'test_user1', 'password' => 'test_user1', 'email' => 'bla@ba.bg' }
    User.new(params).save
  end

  after(:context) do
    user = User.first(:name => 'test_user1')
    user.destroy
  end

  it "fails validation if there is missing param" do
    params = { 'goal_about' => '42' }
    result = Goal.validation params
    expect(result).to eq('Please fill all fields')
  end

  it "failds validation if there is no deadline" do
    params = { 'goal_name' => '42', 'goal_about' => '42', 'goal_how' => '42' }
    expect(Goal.validation params).to eq('Please set your deadline!')
  end

  it "fails if the deadline is not a date" do
    params = { 'goal_name' => '42', 'goal_about' => '42', 'goal_how' => '42', 'goal_deadline' => '42' }
    expect(Goal.validation params).to eq('Please set a valid deadline!')
  end

  it "calculates color as expected" do
    expect(Goal.calculate_color 32).to eq('red')
    expect(Goal.calculate_color 33).to eq('yellow')
    expect(Goal.calculate_color 80).to eq('green')
  end

  it "marks as completed" do
    params = { 'goal_name' => '42', 'goal_about' => '42', 'goal_how' => '42', 'goal_deadline' => '02/02/2017' }
    user = User.first(:name => 'test_user1')
    initial_completed = user.completed_goals
    goal = Goal.new(params,user)
    goal.save
    expect(goal.status).to eq('in_progress')
    goal.mark_as_completed
    user = User.first(:name => 'test_user1')
    expect(initial_completed).to eq(user.completed_goals - 1)
    expect(goal.status).to eq('completed')
  end


end

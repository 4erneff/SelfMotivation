require File.expand_path '../spec_helper.rb', __FILE__

describe "User class" do
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  after(:context) do
    user = User.first(:name => 'test_user1')
    user.destroy
  end

  it "register a new User" do
    params = { 'name' => 'test_user1', 'password' => 'test_user1', 'email' => 'bla@ba.bg' }
    user = User.new params
    user = user.save
    expect(user).to eq(true)
    second_user = User.new(params).save
    expect(second_user).to eq(false)
  end

  it "should allow accessing the home page" do
    get '/'
    expect(last_response).to be_ok
   end

  it "User authenticate" do
    user = User.authenticate('test_user1', 'test_user1')
    expect(user.class).to eq(User)
  end

  it "Fails authentication" do
    user = User.authenticate('test_user1', '00')
    expect(user).to eq(nil)
  end

  it "updates pass_code if password forgotten" do
    allow(EmailSender).to receive(:password_forgotten).and_return(42)

    user = User.first(:name => 'test_user1')
    code_old = user.pass_code
    result = User.password_forgotten('bla@ba.bg')
    expect(result).to eq(42)
    user = User.first(:name => 'test_user1')
    expect(code_old).not_to eq(user.pass_code)
  end

  it "fails password forgotten with wrong mail" do
    result = User.password_forgotten('blaaf')
    expect(result).to eq(nil)
  end

  it "password forgotten change fails with wrong passcode" do
    result = User.password_forgotten_change('0', '42')
    expect(result).to eq(nil)
  end

  it "change forgotten password with valid passcode" do
    user = User.first(:name => 'test_user1')
    old_password = user.password
    result = User.password_forgotten_change(user.pass_code, '42')
    updated_user = User.first(:name => 'test_user1')
    expect(old_password).not_to eq(updated_user.password)
    expect(result).to eq(true)
  end

  it "returns logged user" do
    user = User.first(:name => 'test_user1')
    arg = { :user => user.id }
    expect(user).to eq(User.get_logged_user(arg))
  end

  it "returns nil if no user logged" do
    arg = {}
    expect(nil).to eq(User.get_logged_user(arg))
  end

end

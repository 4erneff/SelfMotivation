class Goal
  include DataMapper::Resource

  property :id, Serial

  property :name, String,
    :required => true

  property :why, String,
    :required => true

  property :how, String,
    :required => true

  property :deadline, Date,
    :required => true

  has n, :metrics

  belongs_to :user, :required => false

  def initialize(params, user)
    self.name = params['goal_name']
    self.why = params['goal_about']
    self.how = params['goal_how']
    params['goal_deadline'].gsub!('/', '-')
    self.deadline = Date.strptime(params['goal_deadline'], '%m-%d-%Y')
    self.metrics = []
    self.user = user
  end

  def to_s
    "Goal #{name} why: #{why}, how: #{how}, deadline: #{deadline} "
  end

  def self.validation(params)
    str_fields = ['goal_name', 'goal_about', 'goal_how']
    str_fields.each do |field|
      if not params[field] or params[field].strip == ""
        return "Please fill all fields"
      end
    end

    if not params['goal_deadline']
      return "Please set yout deadline!"
    end

    p params['goal_deadline']

    deadline = begin
                 Date.strptime(params['goal_deadline'].gsub('/', '-'), '%m-%d-%Y')
               rescue
                 return "Please set a valid deadline!"
               end

    if deadline.to_datetime <= Time.now.to_datetime
      return "Please select deadline in the future!"
    end

    "OK"
  end

end

class Metric
  include DataMapper::Resource

  property :id, Serial

  property :value, String,
    :required => true,
    :messages => {
      :presence => "Each metric must have a value"
    }

  property :about, String,
    :required => true,
    :messages => {
      :presence => "Each metric must refer to something"
    }

  property :aim, Integer,
    :required => true,
    :messages => {
      :presence => "Each metric must have an aimed value"
    }

  property :current, Integer,
    :default => 0

  belongs_to :goal, :required => false

  def initialize(params, goal)
    params.each { |key, value| value.strip! }
    self.value = params['value']
    self.about = params['about']
    self.aim = params['aim']
    self.goal = goal
  end

  def to_s
    "Value - #{value} , about - #{about}, aim - #{aim} \t\n"
  end

end



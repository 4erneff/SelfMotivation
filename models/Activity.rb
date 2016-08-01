class Activity
  include DataMapper::Resource

  property :id, Serial

  property :date, Date

  property :value, Integer

  belongs_to :metric, :required => false

  def initialize(params)
    self.date = Date.strptime(params['date'], '%m-%d-%Y')
    self.value = params['value']
    self.metric = params['metric']
  end

  def self.track_activity(params)
    params['date'].gsub!('/', '-')
    date = Date.strptime(params['date'], '%m-%d-%Y')
    activity = Activity.first(:date => date, :metric => params['metric'])
    if activity
      update_activity activity, params
    else
      add_activity params
    end
  end

  def self.update_activity(activity, params)
    new_value = activity.value + params['value'].to_i
    activity.update(:value => new_value)
    metric = activity.metric
    new_value = metric.current + params['value'].to_i
    metric.update(:current => new_value)
  end

  def self.add_activity(params)
    activity = Activity.new params
    activity.save()
    params['metric'].activities << activity
    params['metric'].current += params['value'].to_i
    params['metric'].save()
  end

end

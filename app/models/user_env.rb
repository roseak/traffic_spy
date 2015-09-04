module TrafficSpy
  class UserEnv < ActiveRecord::Base
    has_many :visits
  end
end

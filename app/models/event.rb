module TrafficSpy
  class Event < ActiveRecord::Base

    has_many :visits
  end
end

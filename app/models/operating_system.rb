module TrafficSpy
  class OperatingSystem < ActiveRecord::Base
    has_many :visits
  end
end

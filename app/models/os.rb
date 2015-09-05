module TrafficSpy
  class Os < ActiveRecord::Base
    has_many :visits
  end
end

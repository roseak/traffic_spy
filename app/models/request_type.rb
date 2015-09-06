module TrafficSpy
  class RequestType < ActiveRecord::Base
    has_many :visits
  end
end

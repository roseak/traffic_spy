module TrafficSpy
  class Url < ActiveRecord::Base

    belongs_to :client
  end
end

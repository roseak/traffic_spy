module TrafficSpy
  class Url < ActiveRecord::Base
    belongs_to :client
    has_many :visits

  end
end

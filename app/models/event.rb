module TrafficSpy
  class Event < ActiveRecord::Base
    has_many :visits

    def self.events_for_a_client(identifier)
      Client.find_by(identifier: identifier).urls.visits.events
    end

  end
end

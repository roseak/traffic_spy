module TrafficSpy
  class Event < ActiveRecord::Base
    has_many :visits

    def self.events_for_a_client(identifier)
      urls = Client.find_by(identifier: identifier).urls
      events = urls.map { |url| url.events }.flatten
      count = events.reduce(Hash.new(0)) do |hash, event|
        hash[event.name] += 1
        hash
      end
    end

  end
end

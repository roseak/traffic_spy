module TrafficSpy
  class Event < ActiveRecord::Base
    has_many :visits

    def self.events_for_a_client(identifier)
      urls = Client.find_by(identifier: identifier).urls
      events = urls.map { |url| url.events }.flatten
      grouped = events.group_by { |event| event.name }
      grouped.map { |event, events| [event, events.length] }.to_h
    end

  end
end

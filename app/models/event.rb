module TrafficSpy
  class Event < ActiveRecord::Base
    has_many :visits

    def self.events_for_a_client(identifier)
      Visit.visits_for_a_client(identifier).map(&:event)
    end

    def self.grouped_events(identifier)
      events_for_a_client(identifier).group_by do |event|
        event.name
      end
    end

    def self.counted_grouped_events(identifier)
      grouped_events(identifier).map  do |event, events|
        [event, events.length]
      end.to_h
    end

    def self.ranked_events_for_a_client(identifier)
      counted_grouped_events(identifier).sort_by do |event, count|
        count
      end.reverse.to_h
    end

  end
end

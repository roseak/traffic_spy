module TrafficSpy
  class Event < ActiveRecord::Base
    has_many :visits

    def self.events_for_a_client(identifier)
      Visit.visits_for_a_client(identifier).map(&:event)
    end

    def self.grouped_events(identifier)
      events_for_a_client(identifier).group_by(&:name)
    end

    def self.counted_grouped_events(identifier)
      grouped_events(identifier).map do |event, events|
        [event, events.length]
      end.to_h
    end

    def self.ranked_events_for_a_client(identifier)
      counted_grouped_events(identifier).sort_by do |_event, count|
        count
      end.reverse.to_h
    end

    def self.ranked_event_counts(identifier)
      ranked_events_for_a_client(identifier).map do |event, count|
        EventCount.new(name: event, count: count)
      end
    end

    def self.max(identifier)
      ranked_events_for_a_client(identifier).first.first
    end

    def self.count_for_client(event, identifier)
      visits_for_a_client = Client.find_by(identifier: identifier).urls
      visits_for_a_client.map(&:visits).flatten.map(&:event).count(event)
    end

    def self.event_and_visit(identifier)
      client = Client.find_by(identifier: identifier)
      visits = client.urls.map(&:visits).flatten
      visits.map do |visit|
        [visit, visit.event]
      end
    end

    def self.relevant_visits(event, identifier)
      event_and_visit(identifier).select do |_visit, v_event|
        v_event.name == event.name
      end
    end
    
    def self.timestamps(event, identifier)
      visits = relevant_visits(event, identifier).map { |v, _e| v }

      visits.map(&:requested_at).map do |time|
        Time.parse(time).strftime("%l:00%P")
      end
    end

    def self.sorted_timestamps(event, identifier)
      timestamps(event, identifier).inject(Hash.new(0)) do |sum, timestamp|
        sum[timestamp] += 1
        sum
      end
    end

    def self.blank_twenty_four_counter
      times = [*1..24].map do |hour| 
        [Time.parse("#{hour}:00").strftime("%l:00%P"), 0]
      end.to_h
    end

    def self.all_sorted_timestamps(event, identifier)
      blank_twenty_four_counter.map do |hour, _count|
        [hour, sorted_timestamps(event, identifier)[hour]]
      end.to_h
    end
  end
end

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

    def self.max(identifier)
      ranked_events_for_a_client(identifier).first.first
    end

    def self.count(event)
      event.visits.size
    end

    def self.timestamps(event)
      event.visits.map(&:requested_at).map do |time|
        hour = Time.parse(time).strftime("%l:00%P")
      end
    end

    def self.sorted_timestamps(event)
      timestamps(event).inject(Hash.new(0)) do |sum, timestamp|
        sum[timestamp] += 1
        sum
      end
    end

    def self.all_sorted_timestamps(event)
      times = Hash.new
      24.times do |hour|
        times[Time.parse("#{hour}:00").strftime("%l:00%P")] = 0
      end
      sorted_timestamps(event).each do |time, hits|
        times[time] = hits
      end
      times
    end
  end
end

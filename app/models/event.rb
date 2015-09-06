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

    def self.ranked_event_counts(identifier)
      ranked_events_for_a_client(identifier).map do |event, count|
        EventCount.new(name: event, count: count)
      end
    end

    def self.max(identifier)
      ranked_events_for_a_client(identifier).first.first
    end

    def self.count_for_client(event, identifier)
      Client.find_by(identifier: identifier).urls
                                            .map(&:visits).flatten
                                            .map(&:event).count(event)
    end

    def self.timestamps(event, identifier)
      client = Client.find_by(identifier: identifier)
      visits = client.urls.map(&:visits).flatten

      event_and_visit = visits.map do |visit|
        [visit, visit.event]
      end

      relevant_visits = event_and_visit.select { |visit, v_event| v_event.name == event.name }
      visits = relevant_visits.map { |v,e| v}
      
      visits.map(&:requested_at).map do |time|
        hour = Time.parse(time).strftime("%l:00%P")
      end
    end

    def self.sorted_timestamps(event, identifier)
      timestamps(event, identifier).inject(Hash.new(0)) do |sum, timestamp|
        sum[timestamp] += 1
        sum
      end
    end

    def self.all_sorted_timestamps(event, identifier)
      times = Hash.new
      24.times do |hour|
        times[Time.parse("#{hour}:00").strftime("%l:00%P")] = 0
      end
      sorted_timestamps(event, identifier).each do |time, hits|
        times[time] = hits
      end
      times
    end
  end
end

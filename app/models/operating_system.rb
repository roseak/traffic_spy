module TrafficSpy
  class OperatingSystem < ActiveRecord::Base
    has_many :visits

    def self.operating_systems_for_a_client(identifier)
      Visit.visits_for_a_client(identifier).map do |visit|
        visit.operating_system
      end
    end

    def self.operating_systems_grouped(identifier)
      operating_systems_for_a_client(identifier).group_by do |os|
        os.operating_system
      end
    end

    def self.ranked_operating_system_visits(identifier)
      operating_systems_grouped(identifier).sort_by do |os, visits|
        visits.length
      end.reverse.to_h
    end

    def self.ranked_operating_systems_with_count(identifier)
      ranked_operating_system_visits(identifier).map do |os, visits|
        [os, visits.length]
      end.to_h
    end
  end
end

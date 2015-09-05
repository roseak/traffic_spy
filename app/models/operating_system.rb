module TrafficSpy
  class OperatingSystem < ActiveRecord::Base
    has_many :visits
  end

  def self.operating_systems_for_a_client(identifier)
    Visit.visits_for_a_client(identifier).map do |visit|
      visit.operating_system
    end
  end
end

module TrafficSpy
  class Resolution < ActiveRecord::Base
    has_many :visits

    def self.ranked_resolutions_by_visit(identifier)
      binding.pry
      Client.find_by(identifier: identifier)
    end
  end
end

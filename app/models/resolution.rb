module TrafficSpy
  class Resolution < ActiveRecord::Base
    has_many :visits

    def self.all_for_client(identifier)
      Client.find_by(identifier: identifier).urls.map(&:resolutions).flatten.map(&:resolution).sort
    end
  end
end

module TrafficSpy
  class Resolution < ActiveRecord::Base
    has_many :visits

    def self.all_for_client(identifier)
      Client.find_by(identifier: identifier).urls.map(&:resolutions).flatten.map(&:resolution).sort
    end

    def self.all_for_client_sorted(identifier)
      all_for_client(identifier).reduce(Hash.new(0)) { |count, resolution|
        count[resolution] += 1
        count
      }
    end
  end
end

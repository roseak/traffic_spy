module TrafficSpy
  class Resolution < ActiveRecord::Base
    has_many :visits

    def self.all_for_client(identifier)
      urls = Client.find_by(identifier: identifier).urls
      urls.map(&:resolutions).flatten.map(&:resolution).sort
    end

    def self.all_for_client_sorted(identifier)
      all_for_client(identifier).inject(Hash.new(0)) do |count, resolution|
        count[resolution] += 1
        count
      end
    end
  end
end

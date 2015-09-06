module TrafficSpy
  class Client < ActiveRecord::Base
    validates :identifier, presence: true
    validates :root_url, presence: true
    validates :identifier, uniqueness: true

    has_many :urls
    has_many :visits, through: :urls

    def self.prep(params)
      { :identifier => params.fetch("identifier", nil), 
        :root_url => params.fetch("rootUrl", nil)}
    end

    def self.avg_response_time(identifier)
      Client.find_by(identifier: identifier).visits.average(:responded_in).to_i
    end
  end
end

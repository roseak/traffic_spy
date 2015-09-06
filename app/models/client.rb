module TrafficSpy
  class Client < ActiveRecord::Base
    validates :identifier, presence: true
    validates :root_url, presence: true
    validates :identifier, uniqueness: true

    has_many :urls

    def self.prep(params)
      { identifier: params.fetch("identifier", nil),
        root_url:   params.fetch("rootUrl", nil) }
    end
  end
end

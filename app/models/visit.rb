module TrafficSpy
  class Visit < ActiveRecord::Base
    belongs_to :url
    belongs_to :referral
    belongs_to :event
    belongs_to :user_env
    belongs_to :request_type
    belongs_to :resolution
    belongs_to :web_browser
    belongs_to :operating_system

    def self.visits_for_a_client(identifier)
      Url.urls_for_a_client(identifier).map do |url|
        url.visits
      end.flatten
    end
  end
end

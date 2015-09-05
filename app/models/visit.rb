module TrafficSpy
  class Visit < ActiveRecord::Base

    belongs_to :url
    belongs_to :referral
    belongs_to :event
    belongs_to :user_env
    belongs_to :request_type
    belongs_to :screen_resolution
    belongs_to :web_browser
    belongs_to :operating_system
  end
end

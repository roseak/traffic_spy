module TrafficSpy
  class Visit < ActiveRecord::Base

    belongs_to :url
    belongs_to :referral
    belongs_to :event
    belongs_to :user_env
    belongs_to :request_type
    belongs_to :screen_resolution
  end
end

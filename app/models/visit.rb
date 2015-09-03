module TrafficSpy
  class Visit < ActiveRecord::Base

    belongs_to :url, :referral, :user_env, :request_type, :event
  end
end

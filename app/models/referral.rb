module TrafficSpy
  class Referral < ActiveRecord::Base
    has_many :visits
  end
end

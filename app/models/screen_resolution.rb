module TrafficSpy
  class ScreenResolution < ActiveRecord::Base


    has_many :visits
  end
end

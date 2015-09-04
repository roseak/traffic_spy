module TrafficSpy
  class WebBrowser < ActiveRecord::Base

    has_many :visits
  end
end
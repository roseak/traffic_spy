module TrafficSpy
  class Url < ActiveRecord::Base
    belongs_to :client
    has_many :visits

    def sorted_ascending
      
    end
  end
end

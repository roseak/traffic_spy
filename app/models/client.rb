module TrafficSpy
  class Client < ActiveRecord::Base
    validates :identifier, presence: true
    validates :root_url, presence: true
    validates :identifier, uniqueness: true

    has_many :urls
  end
end

module TrafficSpy
  class Url < ActiveRecord::Base
    belongs_to :client
    has_many :visits

    def self.urls_for_a_client(identifier)
      Client.find_by(identifier: identifier).urls
    end

    # def self.url_visits(client_identifier)
    #   urls_for_a_client(client_identifier)
    # end


  end
end

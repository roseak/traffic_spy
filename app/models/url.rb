module TrafficSpy
  class Url < ActiveRecord::Base
    belongs_to :client
    has_many :visits
    has_many :events, through: :visits
    has_many :resolutions, through: :visits

    def self.urls_for_a_client(identifier)
      Client.find_by(identifier: identifier).urls
    end

    def self.url_visits(client_identifier)
      urls_for_a_client(client_identifier).map do |url|
        [url, url.visits.count]
      end.to_h
    end

    def self.ranked_url_visits(client_identifier)
      url_visits(client_identifier).sort_by { |url, visits| visits }.reverse.to_h
    end

    def self.ranked_url_string_visits(client_identifier)
      ranked_url_visits(client_identifier).map { |k, v| [tail(k.url), v] }.to_h
    end

    def self.tail(url)
      url.gsub(/https?:\/\/[^\/]*\//, '')
    end
  end
end

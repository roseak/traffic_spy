module TrafficSpy
  class Url < ActiveRecord::Base
    belongs_to :client
    has_many :visits
    has_many :events, through: :visits
    has_many :resolutions, through: :visits
    has_many :referrals, through: :visits
    has_many :web_browsers, through: :visits
    has_many :operating_systems, through: :visits

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

    def self.url_object(identifier, url)
      root_url = Client.find_by(identifier: identifier).root_url
      path = "#{root_url}/#{url}"
      Url.find_by(url: path)
    end

    def self.responded_in(identifier, url)
      times = url_object(identifier, url).visits.map(&:responded_in)
      responded = {
        "Shortest Response Time" => times.min,
        "Longest Response Time" => times.max,
        "Average Response Time" => (times.inject(0) { |sum, time| sum + time.to_i } / times.length).to_s,
      }
    end

    def self.referrers(identifier, url)
      referrals = url_object(identifier, url).visits.map(&:referral)
      referrals.reduce(Hash.new(0)) { |sum, referral|
        sum[referral.referred_by] += 1
        sum
      }
    end

    def self.browsers(identifier, url)
      browsers = url_object(identifier, url).visits.map(&:web_browser)
      browsers.reduce(Hash.new(0)) { |sum, browser|
        sum[browser.browser] += 1
        sum
      }
    end

    def self.operating_systems(identifier, url)
      operating_systems = url_object(identifier, url).visits.map(&:operating_system)
      operating_systems.reduce(Hash.new(0)) { |sum, operating_system|
        sum[operating_system.operating_system] += 1
        sum
      }
    end
  end
end

module TrafficSpy
  class Url < ActiveRecord::Base
    belongs_to :client
    has_many :visits
    has_many :events, through: :visits
    has_many :resolutions, through: :visits
    has_many :referrals, through: :visits
    has_many :web_browsers, through: :visits
    has_many :operating_systems, through: :visits
    has_many :request_type, through: :visits

    def self.urls_for_a_client(identifier)
      Client.find_by(identifier: identifier).urls
    end

    def self.url_visits(client_identifier)
      urls_for_a_client(client_identifier).map do |url|
        [url, url.visits.count]
      end.to_h
    end

    def self.ranked_url_visits(identifier)
      url_visits(identifier).sort_by { |_url, visits| visits }.reverse.to_h
    end

    def self.ranked_url_string_visits(client_identifier)
      ranked_url_visits(client_identifier).map { |k, v| [tail(k.url), v] }.to_h
    end

    def self.tail(url)
      url.gsub(/https?:\/\/[^\/]*\//, "")
    end

    def self.url_object(identifier, url)
      root_url = Client.find_by(identifier: identifier).root_url
      path = "#{root_url}/#{url}"
      Url.find_by(url: path)
    end

    def self.responded_in(identifier, url)
      visits = url_object(identifier, url).visits
      {
        "min" => visits.minimum(:responded_in).to_i,
        "max" => visits.maximum(:responded_in).to_i,
        "avg" => url_object(identifier, url).visits.average(:responded_in).to_i
      }
    end

    def self.referrers(identifier, url)
      referrals = url_object(identifier, url).visits.map(&:referral)
      referrals.inject(Hash.new(0)) do |sum, referral|
        sum[referral.referred_by] += 1
        sum
      end
    end

    def self.browsers(identifier, url)
      browsers = url_object(identifier, url).visits.map(&:web_browser)
      browsers.inject(Hash.new(0)) do |sum, browser|
        sum[browser.browser] += 1
        sum
      end
    end

    def self.operating_systems(identifier, url)
      o_systems = url_object(identifier, url).visits.map(&:operating_system)
      o_systems.inject(Hash.new(0)) do |sum, operating_system|
        sum[operating_system.operating_system] += 1
        sum
      end
    end

    def self.requests_for_a_url(identifier, url)
      url_object(identifier, url).visits.map(&:request_type)
    end

    def self.counted_requests_for_url(identifier, url)
      requests_for_a_url(identifier, url).group_by { |type| type.request_type }
    end

    def self.ranked_request_types_for_url(identifier, url)
      counted_requests_for_url(identifier, url).map do |type, types|
        [type, types.length]
      end.to_h
    end

    def self.has_been_requested?(identifier, url_tail)
      client = Client.find_by(identifier: identifier)
      url = client.root_url + "/" + url_tail
      client.urls.any? { |url_obj| url_obj.url == url }
    end
  end
end

module TrafficSpy
  class UrlData
    attr_accessor :data
    attr_reader :identifier, :url

    def initialize(params)
      @identifier = params[:identifier]
      @url = params[:url]
    end

    def self.prepare(identifier, url)
      url_data = new(identifier: identifier, url: url)
      url_data.data =
      {
        response_stats: url_data.response_stats,
        referrers: url_data.referrers,
        browsers: url_data.browsers,
        operating_systems: url_data.operating_systems,
        request_types: url_data.request_types
      }
    end

    def response_stats
      { :title => "Response Time Statistics",
        :headers => ["Response Time", "Miliseconds"],
        :rows => Url.responded_in(@identifier, @url) }
    end

    def referrers
      { :title => "Most Popular Referrers",
        :headers => ["Referrer", "Count"],
        :rows => Url.referrers(@identifier, @url) }
    end

    def browsers
      { :title => "Most Popular Browsers",
        :headers => ["Browser", "Count"],
        :rows => Url.browsers(@identifier, @url) }
    end

    def operating_systems
      { :title => "Most Popular Operating Systems",
        :headers => ["Operating System", "Count"],
        :rows => Url.operating_systems(@identifier, @url) }
    end

    def request_types
      { :title => "Most Popular Request Types",
        :headers => ["Request Type", "Count"],
        :rows => Url.ranked_request_types_for_url(@identifier, @url) }
    end
  end
end

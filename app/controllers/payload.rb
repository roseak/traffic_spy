# require './app/models/client.rb'

module TrafficSpy
  class Payload
    attr_reader :params

    def initialize(params)
      @params = params
      foreign_tables = {}
      foreign_tables[:url] = Url.create(url_params)
      foreign_tables[:referral] = Referral.create(referral_params)
      foreign_tables[:event] = Event.create(event_params)
      foreign_tables[:user_env] = UserEnv.create(user_env_params)
      foreign_tables[:request_type] = RequestType.create(request_type_params)
      visit = Visit.create(visit_params(foreign_tables))
    end

    def url_params
      {
        "client_id" => params["client_id"],
        "url" => params["url"]
      }
    end

    def referral_params
      { "referred_by" => params["referredBy"] }
    end

    def event_params
      { "event_name" => params["eventName"] }

    end

    def user_env_params
      {
        "user_agent" => params["userAgent"], 
        "resolution_width" => params["resolutionWidth"],
        "resolution_height" => params["resolutionHeight"],
        "ip" => params["ip"]
      }
    end


    def request_type_params
      { "request_type" => params["requestType"] }
    end

    def visit_params(foreign_tables)
      { "requested_at" => params["requestedAt"],
        "responded_in" => params["respondedIn"],
        "url_id" => foreign_tables[:url].id,
        "referral_id" => foreign_tables[:referral].id,
        "event_id" => foreign_tables[:event].id,
        "user_env_id" => foreign_tables[:user_env].id,
        "request_type_id" => foreign_tables[:request_type].id
      }
    end

  end
end


# {"url"=>"http://r3m.com/blog",
#  "requestedAt"=>"2013-02-16 21:38:28 -0700",
#  "respondedIn"=>"37",
#  "referredBy"=>"http://r3m.com",
#  "requestType"=>"GET",
#  "userAgent"=>
#   "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17",
#  "resolutionWidth"=>"1920",
#  "resolutionHeight"=>"1280",
#  "ip"=>"63.29.38.211",
#  "splat"=>[],
#  "captures"=>["r3m"],
#  "identifier"=>"r3m"}

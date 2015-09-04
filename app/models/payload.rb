# require './app/models/client.rb'

module TrafficSpy
  class Payload
    attr_reader :params

    def initialize(params)
      @params = params
                     related_objects = {}
               related_objects[:url] = create_url(url_params)
      related_objects[:request_type] = create_request_type(request_type_params)
          related_objects[:referral] = create_referral(referral_params)
             related_objects[:event] = Event.create(event_params)
          related_objects[:user_env] = UserEnv.create(user_env_params)
                            visit = Visit.create(visit_params(related_objects))
    end

    def self.payload_legit?(params)
      raw_payload = params.fetch('payload', nil) 
      return false if !raw_payload
      return false if params['payload'].nil?
      return false if params['payload'].empty?
      return false if !(params['payload'] =~/[\w]/)
      true
    end

    def create_url(params)
      client = Client.find(params[:client_id])
      client.urls.find_or_create_by(url: params[:url])
    end

    def url_params
      { :client_id => params["client_id"],
              :url => params["url"] }
    end

    def create_request_type(params)
      RequestType.find_or_create_by(params)
    end

    def request_type_params
      { :request_type => params["requestType"] }
    end
    
    def create_referral(params)
      Referral.find_or_create_by(params)
    end

    def referral_params
      { "referred_by" => params["referredBy"] }
    end

    def event_params
      { "name" => params["eventName"] }

    end

    def user_env_params
      {
        "user_agent" => params["userAgent"], 
        "resolution_width" => params["resolutionWidth"],
        "resolution_height" => params["resolutionHeight"],
        "ip" => params["ip"]
      }
    end



    def visit_params(related_objects)
      { "requested_at" => params["requestedAt"],
        "responded_in" => params["respondedIn"],
        "url_id" => related_objects[:url].id,
        "referral_id" => related_objects[:referral].id,
        "event_id" => related_objects[:event].id,
        "user_env_id" => related_objects[:user_env].id,
        "request_type_id" => related_objects[:request_type].id
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

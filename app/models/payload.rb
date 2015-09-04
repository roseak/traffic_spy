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
             related_objects[:event] = create_event(event_params)
      related_objects[:resolution] = create_resolution(screen_res_params)
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

    def create_event(params)
      Event.find_or_create_by(params)
    end

    def event_params
      { "name" => params["eventName"] }
    end

    def create_resolution(params)
      ScreenResolution.find_or_create_by(params)
    end

    def screen_res_params
      res = "#{params["resolutionWidth"]}x#{params["resolutionHeight"]}"
      { :resolution => res }
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
        "resolution_id" => related_objects[:resolution].id,
        "user_env_id" => related_objects[:user_env].id,
        "request_type_id" => related_objects[:request_type].id
      }
    end

  end
end

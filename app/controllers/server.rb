require 'digest'

module TrafficSpy
  class Server < Sinatra::Base
    get '/' do
      erb :index
    end

    post '/sources' do
      prepped = Client.prep(params)
      client = Client.new(prepped)

      if client.save
        body client.attributes.select { |k, v| k == "identifier" }.to_json
      elsif client.errors.full_messages.any? { |error| error.include?("blank") }
        body client.errors.full_messages.first
        status 400
      else
        body client.errors.full_messages.first
        status 403
      end
    end

    get '/sources/:identifier' do |identifier|
      @params = {
        identifier: identifier,
        title: "Statistics",
        path: identifier,
      }

      erb :stats
    end

    get '/sources/:identifier/urls' do |identifier|
      @params = {
        identifier: identifier,
        path: identifier,
        title: "URLs",
        url_title: "URL",
        count_title: "Requests",
        data: Url.ranked_url_string_visits(identifier)
      }

      erb :list
    end

    get '/sources/:identifier/os' do |identifier|
      @params = {
        identifier: identifier,
        path: identifier,
        title: "Operating Systems",
        header: "OS",
        comparison: "Requests",
        data: {
          "OSX YOSEMITE" => 10,
          "WINDOWS XP" => 5,
          "UBUNTU LINUX" => 4,
          "WINDOWS 2000" => 3,
        }
      }
    end

    get '/sources/:identifier/resolution' do |identifier|
      @params = {
        identifier: identifier,
        path: identifier,
        title: "Screen Resolutions",
        header: "Resolution",
        comparison: "Requests",
        data: Resolution.all_for_client_sorted(identifier)
      }

      erb :list
    end

    get '/sources/:identifier/urls/*' do |identifier, url|
      @params = {
        identifier: identifier,
        path: "#{identifier}/#{url}",
        title: "URL Specific Data",
        referrers: {},
        user_agents: {},
      }

      erb :url_specific
    end

    post '/sources/:identifier/data' do |identifier|
      legit = Payload.payload_legit?(params)

      if legit
        raw_payload = params.fetch('payload', nil)
        parsed = JSON.parse(raw_payload)
        client = Client.find_by(identifier: identifier)
        long_string = parsed.values.join
        key = Digest::SHA1.hexdigest(long_string)
      end

      if !legit
        status 400
        body "Payload is empty"
      elsif !client
        status 403
        body "Application not registered"
      elsif Sha.find_by(sha: key)
        status 403
        body "Already received request"
      else
        parsed["client_id"] = "#{client.id}"
        payload = Payload.new(parsed)
        Sha.create(sha: key)
      end
    end

    not_found do
      erb :error
    end
  end

end

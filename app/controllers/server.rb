require 'digest'

module TrafficSpy
  class Server < Sinatra::Base
    get '/' do
      erb :index
    end

    post '/sources' do
      # File.open('./test/params.txt', 'w') { |file| file.write("#{params}") }
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
      }

      erb :stats
    end

    get '/sources/:identifier/urls' do |identifier|
      @params = {
        identifier: identifier,
        path: identifier,
        title: "URLs",
        header: "URL",
        comparison: "Requests",
        data: TrafficSpy::Url.ranked_real_url_visits(identifier),
      }

      erb :urls
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

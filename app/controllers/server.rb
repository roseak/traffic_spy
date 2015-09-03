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
        # binding.pry
        body client.attributes.select { |k, v| k == "identifier" }.to_json
      elsif client.errors.full_messages.any? { |error| error.include?("blank") }
        body client.errors.full_messages.first
        status 400
      else
        body client.errors.full_messages.first
        status 403
      end
    end

    post '/sources/:identifier/data' do |identifier|
      client = Client.find_by(identifier: identifier)
      long_string = params.values.join
      key = Digest::SHA1.hexdigest(long_string)

      if !params["url"]
        require "pry"
        binding.pry
        status 400
        body "Payload is empty"
      elsif !client
        require "pry"
        binding.pry
        status 403
        body "Application not registered"
      elsif Sha.find_by(sha: key)
        require "pry"
        binding.pry
        status 403
        body "Already received request"
      else
        params["client_id"] = "#{client.id}"
        payload = Payload.new(params)
        Sha.create(sha: key)
      end
    end

    not_found do
      erb :error
    end
  end

end

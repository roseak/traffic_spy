module TrafficSpy

  class Server < Sinatra::Base
    get '/' do
      erb :index
    end

    post '/sources' do
      client = Client.new(params)

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

    post '/sources/:identifier/data' do |identifier|
      payload = Payload.new(params)
    end

    not_found do
      erb :error
    end
  end

end

require 'digest'
#require 'sinatra-partial'

module TrafficSpy
  class Server < Sinatra::Base
    register Sinatra::Partial
    set :partial_template_engine, :erb

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
      if Client.find_by(identifier: identifier)
        @params = {
          identifier: identifier,
          title: "Statistics",
          path: identifier,
        }
        erb :stats
      else
        @params = { message: "Identifer Does Not Exist" }
        erb :error
      end

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

    get '/sources/:identifier/events' do |identifier|
      @event_counts = Event.ranked_event_counts(identifier)
      @params = {
        identifier: identifier,
        path: identifier,
        title: "Aggregate Event Data",
        most_received_event: Event.max(identifier),
        events: Event.events_for_a_client(identifier).map(&:name).uniq
      }

      erb :events
    end

    get '/sources/:identifier/os' do |identifier|
      @params = {
        identifier: identifier,
        path: identifier,
        title: "Operating Systems",
        header: "OS",
        comparison: "Requests",
        data: OperatingSystem.ranked_operating_systems_with_count(identifier)
      }

      erb :list
    end

    get '/sources/:identifier/browsers' do |identifier|
      @params = {
        identifier: identifier,
        path: identifier,
        title: "Web Browsers",
        header: "Browsers",
        comparison: "Requests",
        data: WebBrowser.ranked_web_browsers_with_count(identifier)
      }

      erb :list
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
      if Url.has_been_requested?(identifier, url)
        @params = {
          identifier: identifier,
          path: "#{identifier}/#{url}",
          title: "URL Specific Data",
          data: Url.responded_in(identifier, url),
          referrers: Url.referrers(identifier, url),
          browsers: Url.browsers(identifier, url),
          operating_systems: Url.operating_systems(identifier, url),
          http_verbs: Url.request_types(identifier, url),
        }
        erb :url_specific
      else
        @params = { message: "Url has not been requested" }
        erb :error
      end
    end

    get '/sources/:identifier/events/*' do |identifier, event|
      if Event.find_by(name: event)
        this_event = Event.find_by(name: event)
        @params = {
          identifier: identifier,
          path: "#{identifier} - #{event}",
          title: "Event Specific Data",
          total: Event.count_for_client(this_event, identifier),
          data: Event.all_sorted_timestamps(this_event, identifier),
        }
        erb :event
      else
        @params = { message: "No event with that name has been defined." }
        erb :error
      end
    end

    get '/sources/:identifier/responsetime' do |identifier|
      @time = Client.avg_response_time(identifier)

      erb :response_time
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

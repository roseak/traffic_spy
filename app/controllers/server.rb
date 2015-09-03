require 'digest'

module TrafficSpy
  class Server < Sinatra::Base

    # This is testing for views
    
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
        data: {
          "blog" => 10,
          "articles/1" => 10,
          "pizza" => 9,
        }
      }

      erb :urls
    end

    get '/sources/:identifier/browsers' do |identifier|
      @params = {
        identifier: identifier,
        path: identifier,
        title: "Web Browsers",
        header: "Browser",
        comparison: "Requests",
        data: {
          "SAFARI" => 10,
          "CHROME" => 3,
          "MOZILLA" => 9,
        }
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

      erb :list
    end

    get '/sources/:identifier/resolution' do |identifier|
      @params = {
        identifier: identifier,
        path: identifier,
        title: "Screen Resolution",
        header: "Resolution",
        comparison: "Requests",
        data: {
          "1920 × 1080" => 10,
          "640 × 480" => 5,
          "1440 × 1024" => 4,
          "100 × 100" => 3,
        }
      }

      erb :list
    end
    
    get '/sources/:identifier/responsetime' do |identifier|
      @params = {
        identifier: identifier,
        path: identifier,
        title: "Screen Resolution",
        header: "URL",
        comparison: "Average Response Time",
        data: {
          "#{identifier}/blog" => 10,
          "#{identifier}/images" => 7,
          "#{identifier}/something" => 2,
        }
      }

      erb :list
    end

    get '/sources/:identifier/urls/*' do |identifier, path|
      @params = {
        identifier: identifier,
        path: "#{identifier}/#{path}",
        title: "URL-Specific Data",
        data: {
          "Longest Response Time" => 10,
          "Shortest Response Time" => 5,
          "Average Response Time" => 7,
          "HTTP Verbs Used" => ["GET", "POST", "PUSH"].join(", "),
        },
        referrers: {
          "www.facebook.com" => 10,
          "www.google.com" => 6,
        },
        user_agents: {
          "Mozilla/4.0 (compatible; MSIE 7.0; AOL 9.1; AOLBuild 4334.5000; Windows NT 5.1; Media Center PC 3.0; .NET CLR 1.0.3705; .NET CLR 1.1.4322; InfoPath.1)" => 2,
          "Mozilla/5.0 (Windows NT 6.3; rv:36.0) Gecko/20100101 Firefox/36.0" => 1,
        }
      }

      erb :url_specific
    end

    get '/sources/:identifier/events' do |identifier|
      @params = {
        identifier: identifier,
        path: "#{identifier}/events",
        title: "Aggregate Event Data",
        most_received_event: "SOME_EVENT",
        events: [
          "startedRegistration",
          "addedSocialThroughPromptA",
          "addedSocialThroughPromptB",
        ]
      }

      erb :events
    end
  end
end

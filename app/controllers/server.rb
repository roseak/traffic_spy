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
        title: "URLs",
        header: "URL",
        comparison: "Requests",
        data: {
          "#{identifier}/blog" => 10,
          "#{identifier}/something" => 10,
          "#{identifier}/blog" => 9,
          "#{identifier}/abas" => 8,
          "#{identifier}/lkjsdf" => 7,
          "#{identifier}/lkja" => 5,
          "#{identifier}/lkj" => 4,
        }
      }

      erb :list
    end

    get '/sources/:identifier/browsers' do |identifier|
      @params = {
        identifier: identifier,
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
        identifier: "#{identifier}/#{path}",
        title: "URL-Specific Data",
        data: {
          "Longest Response Time" => 10,
          "Shortest Response Time" => 5,
          "Average Response Time" => 7,
          "HTTP Verbs Used" => ["GET", "POST", "PUSH"].join(", "),
          "Most Popular Referrers" => ["www.facebook.com", "www.google.com"].join(", "),
          "Most Popular User Agents" => ["Mozilla", "Chrome"].join(", "),
        }
      }

      erb :list
    end
  end
end

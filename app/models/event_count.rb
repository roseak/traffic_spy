module TrafficSpy
  class EventCount
    attr_reader :name, :count
    def initialize(args)
      @name = args[:name]
      @count = args[:count]
    end
  end
end
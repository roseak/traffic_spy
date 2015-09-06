module TrafficSpy
  class TableData

    def initialize(params)
      params.each do |key, value| 
        instance_variable_set("@#{key}", value)
        class_eval{attr_reader key.to_sym}
      end
    end

  end
end
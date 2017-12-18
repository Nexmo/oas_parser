module OasParser
  class Endpoint
    attr_accessor :method, :raw

    def initialize(method, raw)
      @method = method
      @raw = raw
    end
  end
end

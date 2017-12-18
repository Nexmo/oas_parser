module OasParser
  class Endpoint
    attr_accessor :path, :method, :raw

    def initialize(path, method, raw)
      @path = path
      @method = method
      @raw = raw
    end

    def definition
      path.definition
    end
  end
end

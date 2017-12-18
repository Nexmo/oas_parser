module OasParser
  class Endpoint
    include OasParser::RawAccessor
    raw_keys :description, :summary, :operationId, :tags, :required

    attr_accessor :path, :method, :raw

    def initialize(path, method, raw)
      @path = path
      @method = method
      @raw = raw
    end

    def definition
      path.definition
    end

    def parameters
      local_parameters + path.parameters
    end

    def responses
      raw['responses'].map do |code, definition|
        OasParser::Response.new(self, code, definition)
      end
    end

    private

    def local_parameters
      raw['parameters'].map do |definition|
        OasParser::Parameter.new(self, definition)
      end
    end
  end
end

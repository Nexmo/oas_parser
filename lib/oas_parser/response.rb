module OasParser
  class Response
    # include OasParser::RawAccessor
    # raw_keys :description, :summary, :operationId, :tags, :required

    attr_accessor :endpoint, :code, :raw

    def initialize(endpoint, code, raw)
      @endpoint = endpoint
      @code = code
      @raw = raw
    end
  end
end

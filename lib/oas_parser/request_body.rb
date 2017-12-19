module OasParser
  class RequestBody < Payload
    include OasParser::RawAccessor
    raw_keys :description, :required, :content

    attr_accessor :endpoint, :raw

    def initialize(endpoint, raw)
      @endpoint = endpoint
      @raw = raw
    end
  end
end

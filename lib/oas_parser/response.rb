module OasParser
  class Response < Payload
    include OasParser::RawAccessor
    raw_keys :description, :content

    attr_accessor :endpoint, :code, :raw

    def initialize(endpoint, code, raw)
      @endpoint = endpoint
      @code = code
      @raw = raw
    end
  end
end

module OasParser
  class Response
    include OasParser::RawAccessor
    raw_keys :description, :content

    attr_accessor :endpoint, :code, :raw

    def initialize(endpoint, code, raw)
      @endpoint = endpoint
      @code = code
      @raw = raw
    end

    def formats
      content.keys
    end

    def schema(format)
      content[format]['schema']
    end
  end
end

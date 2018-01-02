module OasParser
  class RequestBody < Payload
    include OasParser::RawAccessor
    raw_keys :description, :required, :content

    attr_accessor :endpoint, :raw

    def initialize(endpoint, raw)
      @endpoint = endpoint
      @raw = raw
    end

    def properties_for_format(format)
      schema(format)['properties'].map do |name, definition|
        OasParser::Property.new(self, schema(format), name, definition)
      end
    end

    def split_properties_for_format(format)
      split_schemas(format).map do |schema|
        schema['properties'].map do |name, definition|
          OasParser::Property.new(self, schema(format), name, definition)
        end
      end
    end
  end
end

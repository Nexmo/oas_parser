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
      s = schema(format)
      s = handle_all_of(s)
      s['properties'].map do |name, definition|
        OasParser::Property.new(self, s, name, definition)
      end
    end

    def split_properties_for_format(format)
      split_schemas(format).map do |schema|
        schema = handle_all_of(schema)
        schema['properties'].map do |name, definition|
          OasParser::Property.new(self, schema(format), name, definition)
        end
      end
    end

    def handle_all_of(schema)
      if schema['allOf']
        schema['allOf'].each do |p|
          schema.deep_merge!(p)
        end
        schema.delete('allOf')
      end
      schema
    end
  end
end

module OasParser
  class Property < AbstractAttribute
    raw_keys :description, :type, :format, :minimum, :maximum,
             :example, :default, :items

    attr_accessor :owner, :schema, :raw
    attr_writer :name

    def initialize(owner, schema, name, raw)
      @owner = owner
      @name = name
      @schema = schema
      @raw = raw
    end

    def required
      return true if raw['required']
      return false unless schema['required']
      schema['required'].include? name
    end

    def convert_property_schema_to_properties(schema)
      schema = schema['properties'] if schema['properties']
      schema.map do |name, definition|
        OasParser::Property.new(self, raw, name, definition)
      end
    end
  end
end

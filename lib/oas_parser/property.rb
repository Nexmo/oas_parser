module OasParser
  class Property
    include OasParser::RawAccessor
    raw_keys :name, :description, :type, :enum, :minimum, :maximum,
             :example, :default, :items

    attr_accessor :owner, :name, :schema, :raw

    def initialize(owner, schema, name, raw)
      @owner = owner
      @name = name
      @schema = schema
      @raw = raw
    end

    def required
      return false unless schema['required']
      schema['required'].include? name
    end

    def array?
      type == 'array'
    end

    def object?
      type == 'object'
    end

    def collection?
      array? || object?
    end

    def properties
      return convert_property_schema_to_properties(raw['properties']) if object?
      return convert_property_schema_to_properties(items) if array?
      nil
    end

    def convert_property_schema_to_properties(schema)
      schema = schema['properties'] if schema['properties']
      schema.map do |name, definition|
        OasParser::Property.new(self, raw, name, definition)
      end
    end
  end
end

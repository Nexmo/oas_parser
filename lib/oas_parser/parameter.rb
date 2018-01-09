module OasParser
  class Parameter
    include OasParser::RawAccessor
    raw_keys :name, :in, :description, :style, :enum, :schema,
             :minimum, :maximum, :required

    attr_accessor :owner, :raw

    def initialize(owner, raw)
      @owner = owner
      @raw = raw
    end

    def type
      raw['type'] || schema['type']
    end

    def format
      raw['format'] || schema['format']
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

    def items
      schema['items']
    end

    def example
      raw['example'] || schema['example']
    end

    def default
      raw['default'] || schema['default']
    end

    def properties
      return convert_property_schema_to_properties(raw['properties']) if object?
      return convert_property_schema_to_properties(items) if array?
      nil
    end

    def convert_property_schema_to_properties(schema)
      schema.map do |name, definition|
        OasParser::Property.new(self, raw, name, definition)
      end
    end
  end
end

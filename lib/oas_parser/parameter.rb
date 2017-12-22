module OasParser
  class Parameter
    include OasParser::RawAccessor
    raw_keys :name, :in, :description, :style, :enum, :schema,
             :minimum, :maximum, :example, :default, :required

    attr_accessor :owner, :raw

    def initialize(owner, raw)
      @owner = owner
      @raw = raw
    end

    def type
      raw['type'] || schema['type']
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

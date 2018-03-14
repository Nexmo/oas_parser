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
      if schema['oneOf']
        schema['oneOf'].map do |subschema|
          subschema['properties'] = convert_property_schema_to_properties(subschema)
          subschema['subschema_property'] = true
          subschema
        end
      elsif schema['subschema_property']
        schema = schema['properties'] if schema['properties']
        schema.map do |definition|
          OasParser::Property.new(self, raw, definition.name, definition)
        end
      else
        schema = schema['properties'] if schema['properties']
        schema.map do |key, definition|
          OasParser::Property.new(self, raw, key, definition)
        end
      end
    end
  end
end

module OasParser
  class Property
    include OasParser::RawAccessor
    raw_keys :name, :description, :type, :enum, :minimum, :maximum,
             :example, :default 

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
  end
end

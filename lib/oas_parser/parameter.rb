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
  end
end

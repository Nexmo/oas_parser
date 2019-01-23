module OasParser
  class Parameter
    attr_accessor :name, :in, :description, :required, :deprecated, :allow_empty_value
    def initialize(raw)
      @name = raw['name']
      @in = raw['in']
      @description = raw['description']
      @required = raw['required']
      @deprecated = raw['deprecated']
      @allow_empty_value = raw['allowEmptyValue']
    end
  end
end

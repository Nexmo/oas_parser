module OasParser
  class ServerVariable
    attr_accessor :default, :enum, :description

    def initialize(raw)
      raise InvalidServerVariableError unless raw['default']

      @default = raw['default']
      @enum = raw['enum']
      @description = raw['description'] || ''
    end
  end
end

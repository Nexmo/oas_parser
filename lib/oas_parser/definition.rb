module OasParser
  attr_reader :info

  class Definition
    attr_accessor :info

    def self.resolve(path)
      raw = Parser.resolve(path)
      Definition.new(raw, path)
    end

    def initialize(raw, path)
      @raw = raw
      @path = path

      @info = OasParser::Info.new(raw['info'])
    end
  end
end

module OasParser
  attr_reader :info

  class Definition
    attr_accessor :openapi, :info, :servers

    def self.resolve(filename)
      raw = Parser.resolve(filename)
      Definition.new(raw, filename)
    end

    def initialize(raw, filename)
      @raw = raw
      @filename = filename

      @info = OasParser::Info.new(raw['info'])
      @servers = raw['servers'].map { |s| OasParser::Server.new(s) }
    end
  end
end

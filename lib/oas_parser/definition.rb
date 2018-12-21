module OasParser
  attr_reader :info

  class Definition
    attr_accessor :openapi, :info, :servers

    def self.resolve(path)
      raw = Parser.resolve(path)
      Definition.new(raw, path)
    end

    def initialize(raw, path)
      @raw = raw
      @path = path

      @info = OasParser::Info.new(raw['info'])
      @servers = raw['servers'].map { |s| OasParser::Server.new(s) }
    end
  end
end

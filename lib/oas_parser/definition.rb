module OasParser
  class Definition
    attr_accessor :raw

    def self.resolve(path)
      raw = Parser.resolve(path)
      Definition.new(raw)
    end

    def initialize(raw)
      @raw = raw
    end

    def paths
      raw['paths'].map do |path, definition|
        OasParser::Path.new(self, path, definition)
      end
    end

    def endpoints
      paths.flat_map(&:endpoints)
    end

    def method_missing(m, *args, &block)
      super unless %i[info servers components openapi].include? m
      raw[m.to_s]
    end

    def respond_to_missing?(method_name, include_private = false)
      super unless %i[info servers components openapi)].include? m
      true
    end
  end
end

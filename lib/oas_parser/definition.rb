module OasParser
  class Definition
    include OasParser::RawAccessor
    raw_keys :info, :servers, :components, :openapi

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

    def security
      raw['security'] || {}
    end

    def endpoints
      paths.flat_map(&:endpoints)
    end
  end
end

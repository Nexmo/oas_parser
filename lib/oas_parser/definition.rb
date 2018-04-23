module OasParser
  class Definition
    include OasParser::RawAccessor
    raw_keys :info, :servers, :components, :openapi
    attr_reader :path

    attr_accessor :raw

    def self.resolve(path)
      raw = Parser.resolve(path)
      Definition.new(raw, path)
    end

    def initialize(raw, path)
      @raw = raw
      @path = path
    end

    def format
      File.extname(@path).sub('.', '')
    end

    def paths
      raw['paths'].map do |path, definition|
        OasParser::Path.new(self, path, definition)
      end
    end

    def path_by_path(path)
      definition = raw['paths'][path]
      raise StandardError.new('So such path exists') unless definition
      OasParser::Path.new(self, path, definition)
    end

    def security
      raw['security'] || []
    end

    def endpoints
      paths.flat_map(&:endpoints)
    end
  end
end

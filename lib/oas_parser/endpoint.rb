module OasParser
  class Endpoint
    include OasParser::RawAccessor
    raw_keys :summary, :description, :operationId, :tags, :required

    attr_accessor :path, :method, :raw

    def initialize(path, method, raw)
      @path = path
      @method = method
      @raw = raw
    end

    def definition
      path.definition
    end

    def parameters
      local_parameters + path.parameters
    end

    def path_parameters
      parameters.select { |parameter| parameter.in == 'path' }
    end

    def query_parameters
      parameters.select { |parameter| parameter.in == 'query' }
    end

    def parameter_by_name(name)
      parameters.each do |parameter|
        return parameter if parameter.name == name
      end

      raise StandardError.new('So such parameter exists')
    end

    def request_body
      return false unless raw['requestBody']
      OasParser::RequestBody.new(self, raw['requestBody'])
    end

    def responses
      raw['responses'].map do |code, definition|
        OasParser::Response.new(self, code, definition)
      end
    end

    def response_by_code(code)
      definition = raw['responses'][code]
      raise StandardError.new('So such response exists') unless definition
      OasParser::Response.new(self, code, definition)
    end

    def security
      raw['security'] || {}
    end

    def callbacks
      return [] unless raw['callbacks']
      raw['callbacks'].map do |name, definition|
        OasParser::Callback.new(self, name, definition)
      end
    end

    def jwt?
      return false unless security

      security_schemes = (security.keys + definition.security.keys).uniq

      security_schemes.each do |security_scheme_name|
        security_schema = definition.components['securitySchemes'][security_scheme_name]
        return true if security_schema['bearerFormat'] == 'JWT'
      end

      false
    end

    private

    def local_parameters
      return [] unless raw['parameters']
      raw['parameters'].map do |definition|
        OasParser::Parameter.new(self, definition)
      end
    end
  end
end

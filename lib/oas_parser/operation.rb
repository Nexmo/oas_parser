module OasParser
  class Operation
    attr_accessor :responses, :tags, :summary, :description, :operation_id, :deprecated, :external_docs, :request_body, :parameters, :callbacks, :security, :servers

    def initialize(raw)
      raise InvalidOperationError unless raw['responses']

      @responses = raw['responses'].map { |code, details| [code, OasParser::Response.new(details)] }.to_h

      @tags = raw['tags'] || []
      @summary = raw['summary'] || ''
      @description = raw['description'] || ''
      @operation_id = raw['operationId'] || ''
      @deprecated = raw['deprecated']

      @external_docs = OasParser::ExternalDocs.new(raw['externalDocs']) if raw['externalDocs']
      @request_body = OasParser::RequestBody.new(raw['requestBody']) if raw['requestBody']
      @parameters = raw['parameters'].map { |s| OasParser::Parameter.new(s) } if raw['parameters']
      @callbacks = {} # TODO: Map from raw input
      @security = [] # TODO: Map from raw input

      @servers = raw['servers'].map { |s| OasParser::Server.new(s) } if raw['servers']
    end
  end
end

module OasParser
  class PathItem
    attr_accessor :summary, :description, :get, :put, :post, :delete, :options, :head, :patch, :trace, :servers, :parameters

    def initialize(raw)
      @summary = raw['summary'] || ''
      @description = raw['description'] || ''
      @get = OasParser::Operation.new(raw['get']) if raw['get']
      @put = OasParser::Operation.new(raw['put']) if raw['put']
      @post = OasParser::Operation.new(raw['post']) if raw['post']
      @delete = OasParser::Operation.new(raw['delete']) if raw['delete']
      @options = OasParser::Operation.new(raw['options']) if raw['options']
      @head = OasParser::Operation.new(raw['head']) if raw['head']
      @patch = OasParser::Operation.new(raw['patch']) if raw['patch']
      @trace = OasParser::Operation.new(raw['trace']) if raw['trace']

      @servers = []
      @servers = raw['servers'].map { |s| OasParser::Server.new(s) } if raw['servers']

      @parameters = {} # TODO: Map from raw input
    end
  end
end

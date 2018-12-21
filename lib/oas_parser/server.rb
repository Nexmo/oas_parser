module OasParser
  class Server
    attr_accessor :url, :description, :variables

    def initialize(raw)
      raise InvalidServerError unless raw['url']

      @url = raw['url']
      @description = raw['description'] || ''
      @variables = raw['variables'].nil? ? {} : raw['variables'].map do |k,v|
        [k, ServerVariable.new(v)]
      end.to_h || {}
    end
  end
end

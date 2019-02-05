module OasParser
  class Response
    attr_accessor :description, :headers, :content, :links
    def initialize(raw)
      raise InvalidResponseError unless raw['description']
      @description = raw['description']
      @headers = {} # TODO
      @content = {} # TODO
      @links: {} # TODO
    end
  end
end

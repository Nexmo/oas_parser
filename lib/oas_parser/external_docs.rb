module OasParser
  class ExternalDocs
    attr_accessor :description, :url
    def initialize(raw)
      raise InvalidExternalDocsError unless raw['url']

      @url = raw['url']
      @description = raw['description']
    end
  end
end

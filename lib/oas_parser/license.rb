module OasParser
  class License
    attr_accessor :name, :url

    def initialize(raw)
      @name = raw['name']
      @url = raw['url']
    end
  end
end

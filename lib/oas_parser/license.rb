module OasParser
  class License
    attr_accessor :name, :url

    def initialize(raw)
      raise InvalidLicenseError unless raw['name']
      @name = raw['name']
      @url = raw['url'] || ''
    end
  end
end

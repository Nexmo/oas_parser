module OasParser
  class Info
    attr_accessor :title, :description, :termsOfService, :version, :license, :contact

    def initialize(raw)
      @title = raw['title']
      @description = raw['description']
      @termsOfService = raw['termsOfService']
      @version = raw['version']
      @license = License.new(raw['license'])
      @contact = Contact.new(raw['contact'])
    end
  end
end

module OasParser
  class Info
    attr_accessor :title, :description, :termsOfService, :version, :license, :contact

    def initialize(raw)
      ['title', 'version'].each do |k|
        raise InvalidInfoError unless raw[k]
      end

      @title = raw['title']
      @version = raw['version']
      @description = raw['description']
      @termsOfService = raw['termsOfService']
      @license = License.new(raw['license'])
      @contact = Contact.new(raw['contact'])
    end
  end
end

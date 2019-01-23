module OasParser
  class Info
    attr_accessor :title, :description, :terms_of_service, :version, :license, :contact

    def initialize(raw)
      %w[title version].each do |k|
        raise InvalidInfoError unless raw[k]
      end

      @title = raw['title']
      @version = raw['version']
      @description = raw['description']
      @terms_of_service = raw['termsOfService']
      @license = License.new(raw['license'])
      @contact = Contact.new(raw['contact'])
    end
  end
end

module OasParser
  class Contact
    attr_accessor :name, :url, :email

    def initialize(raw)
      @name = raw['name']
      @url = raw['url']
      @email = raw['email']
    end
  end
end

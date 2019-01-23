module OasParser
  class Pointer
    def initialize(raw_pointer)
      @raw_pointer = raw_pointer
    end

    def resolve(document)
      return document if escaped_pointer == ''

      tokens.reduce(document) do |nested_doc, token|
        nested_doc.fetch(token)
      end
    end

    private

    def escaped_pointer
      if @raw_pointer.start_with?('#')
        Addressable::URI.unencode(@raw_pointer[1..-1])
      else
        @raw_pointer
      end
    end

    def parse_token(token)
      if token =~ /\A\d+\z/
        token.to_i
      else
        token.gsub('~0', '~').gsub('~1', '/')
      end
    end

    def tokens
      tokens = escaped_pointer[1..-1].split('/')

      tokens << '' if @raw_pointer.end_with?('/')

      tokens.map do |token|
        parse_token(token)
      end
    end
  end
end

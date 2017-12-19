module OasParser
  class Payload
    def formats
      content.keys
    end

    def schema(format)
      content[format]['schema']
    end
  end
end

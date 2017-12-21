module OasParser
  class Payload
    def formats
      return [] unless content
      content.keys
    end

    def schema(format)
      content[format]['schema']
    end

    def split_schemas(format)
      content[format]['schema']['oneOf']
    end

    def exhibits_one_of_multiple_schemas?
      return false unless content
      content['application/json']['schema'].keys.include?('oneOf')
    end
  end
end

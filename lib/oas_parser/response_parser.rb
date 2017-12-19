module OasParser
  class ResponseParser
    attr_accessor :raw

    def initialize(raw)
      @raw = raw
    end

    def parse
      route(@raw)
    end

    private

    def route(root_object)
      case root_object['type']
      when 'object' then parse_object(root_object)
      when 'array' then parse_array(root_object)
      when nil
        return nil if root_object['additionalProperties'] == false
        return nil if root_object['properties'] == {}

        if treat_as_object?(root_object)
          # Handle objects with missing type
          return parse_object(root_object.merge({ 'type' => 'object' }))
        end

        raise StandardError.new("Unhandled object with missing type")
      else
        raise StandardError.new("Don't know how to parse #{root_object['type']}")
      end
    end

    def parse_object(object)
      raise StandardError.new("Not a hash") unless object.class == Hash
      raise StandardError.new("Not an object") unless object['type'] == 'object'

      if object['allOf']
        merged_object = { 'type' => 'object' }
        object['allOf'].each { |o| merged_object.deep_merge!(o) }
        return parse_object(merged_object)
      elsif object['properties']
        o = {}
        object['properties'].each do |key, value|
          o[key] = parameter_value(value)
        end

        return o
      end

      {}
    end

    def parse_array(object)
      raise StandardError.new("Not an array") unless object['type'] == 'array'

      case object['items']['type']
      when 'object'
        [parse_object(object['items'])]
      else
        if object['items']
          # Handle objects with missing type
          object['items']['type'] = 'object'
          [parse_object(object['items'])]
        else
          raise StandardError.new("parse_array: Don't know how to parse object")
        end
      end
    end

    def parameter_value(parameter)
      return parameter['example'] if parameter['example']
      case (parameter['schema'] ? parameter['schema']['type'] : parameter['type'])
      when 'integer' then return 1
      when 'number' then return 1.0
      when 'string' then return 'abc123'
      when 'boolean' then return false
      when 'object' then return parse_object(parameter)
      when 'array' then return parse_array(parameter)
      else
        raise StandardError.new("Can not resolve parameter type of #{parameter['type']}")
      end
    end


    def treat_as_object?(object)
      return true if object['type'] == 'object'
      return true if object['allOf']
      return true if object['properties']
      false
    end
  end
end

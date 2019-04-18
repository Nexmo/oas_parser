module OasParser
  class Parser
    def self.resolve(path)
      content = YAML.load_file(path)
      Parser.new(path, content).resolve
    end

    def initialize(path, content)
      @path = path
      @content = content
    end

    def resolve
      deeply_expand_refs(@content)
    end

    private

    def deeply_expand_refs(fragment)
      fragment = expand_refs(fragment)

      if fragment.is_a?(Hash)
        fragment.reduce({}) do |hash, (k, v)|
          hash.merge(k => deeply_expand_refs(v))
        end
      elsif fragment.is_a?(Array)
        fragment.map { |e| deeply_expand_refs(e) }
      else
        fragment
      end
    end

    def expand_refs(fragment)
      if fragment.is_a?(Hash) && fragment.has_key?("$ref")
        ref = fragment["$ref"]

        if ref =~ /^#/
          expand_pointer(ref)
        elsif ref =~ /^(http(s)?|\/\/)/
          expand_url(ref)
        else
          expand_file(ref)
        end
      else
        fragment
      end
    end

    def expand_file(ref)
      absolute_path = File.expand_path(File.join("..", ref), @path)
      absolute_path, local_reference = absolute_path.split('#')
      resolved_remote_reference = Parser.resolve(absolute_path)

      if local_reference
        pointer = OasParser::Pointer.new(local_reference)
        return pointer.resolve(resolved_remote_reference)
      end

      resolved_remote_reference
    end

    def expand_pointer(ref, content=nil)
      pointer = OasParser::Pointer.new(ref)
      fragment = pointer.resolve(content || @content)

      expand_refs(fragment)
    end

    def expand_url(ref)
      raise 'Expanding URL References is not supported'
    end
  end
end

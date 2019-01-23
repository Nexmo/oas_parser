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
      if fragment.is_a?(Hash) && fragment.key?('$ref')
        ref = fragment['$ref']

        if ref =~ /\Afile:/
          expand_file(ref)
        else
          expand_pointer(ref)
        end
      else
        fragment
      end
    end

    def expand_file(ref)
      relative_path = ref.split(':').last
      absolute_path = File.expand_path(File.join('..', relative_path), @path)

      Parser.resolve(absolute_path)
    end

    def expand_pointer(ref)
      pointer = OasParser::Pointer.new(ref)
      fragment = pointer.resolve(@content)

      expand_refs(fragment)
    end
  end
end

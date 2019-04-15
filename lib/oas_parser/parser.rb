module OasParser
  class Parser
    def self.resolve(path)
      content = YAML.load_file(path)
      Parser.new(path, content).resolve
    end

    def initialize(path, content)
      @path = path
      @content = content
      @pointers_resolved = Hash.new
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
      if local_reference
        # skip first item in the split array, it is blank
        local_reference_path = local_reference.split('/')[1..-1]
        resolved_remote_reference = Parser.resolve(absolute_path)

        # expand the pointer included as part of the remote reference 
        # within the context of the remote reference
        expanded_pointer = expand_pointer('#' + local_reference, resolved_remote_reference)
        
        # extract the local reference data from the remote remote reference
        # and include the expanded pointer
        resolved_remote_reference.dig(*local_reference_path).merge(expanded_pointer)
      else
        Parser.resolve(absolute_path)
      end
    end

    def expand_pointer(ref, content=nil)
      unless @pointers_resolved.key?(ref)
        @pointers_resolved[ref] = nil
        pointer = OasParser::Pointer.new(ref)
        fragment = pointer.resolve(content || @content)
        # If this fragment contains any recursive definitions, remove them
        fragment = remove_recursive(fragment, ref)

        @pointers_resolved[ref] = expand_refs(fragment)
      end
      @pointers_resolved[ref]
    end

    def remove_recursive(fragment, ref)
      # This method checks `fragment` (which is a data structure) for any usage
      # of `ref`, which is a string. This is called whenever a reference is
      # detected when resolving a pointer.
      #
      # If we follow a pointer (which gives us `fragment`) and find `ref` in any
      # fields contained within that fragment, we have a recursive definition
       fragment.each do |k,v|

        # If it's an array there isn't a key, so take the entire
        # entry as the value
        v=k if v.nil?

        if v.is_a?(Hash) or v.is_a?(Array)
          v = remove_recursive(v,ref)
        elsif v.to_s == ref
          warn "Error trying to parse. Recursive on #{ref}"
          fragment.delete(k)
        end
      end
      fragment
    end

    def expand_url(ref)
      raise 'Expanding URL References is not supported'
    end
  end
end

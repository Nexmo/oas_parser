module OasParser
  class Parameter
    include OasParser::RawAccessor
    raw_keys :name, :in, :description, :style, :type, :enum

    attr_accessor :owner, :raw

    def initialize(owner, raw)
      @owner = owner
      @raw = raw
    end

    def required
      return true if local_required
      return true if owner_required
      false
    end

    private

    def local_required
      raw['required']
    end

    def owner_required
      return false unless owner.required
      owner.required.include? name
    end
  end
end

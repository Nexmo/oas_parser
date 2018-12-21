module OasParser

  # @abstact Exceptions raised by OasParser inherit from Error
  class Error < StandardError; end

  class InvalidSchemaError < Error; end

  # Info errors
  class InvalidInfoError < InvalidSchemaError;
    def initialize(msg = "Invalid Info provided. See https://swagger.io/specification/#infoObject")
      super(msg)
    end
  end

  # License errors
  class InvalidLicenseError < InvalidSchemaError;
    def initialize(msg = "Invalid Info provided. See https://swagger.io/specification/#licenseObject")
      super(msg)
    end
  end

  # Server errors
  class InvalidServerError < InvalidSchemaError;
    def initialize(msg = "Invalid Server provided. See https://swagger.io/specification/#serverObject")
      super(msg)
    end
  end

  # Server Variable errors
  class InvalidServerVariableError < InvalidSchemaError;
    def initialize(msg = "Invalid Server Variable provided. See https://swagger.io/specification/#serverVariableObject")
      super(msg)
    end
  end

end

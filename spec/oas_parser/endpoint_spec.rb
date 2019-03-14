RSpec.describe OasParser::Endpoint do
  before do
    @definition = OasParser::Definition.resolve('spec/fixtures/petstore-expanded.yml')
    @path = @definition.path_by_path('/pets')
    @endpoint = @path.endpoint_by_method('get')
  end

  describe '#definition' do
    it 'returns the parent definition' do
      expect(@endpoint.definition).to eq(@definition)
    end
  end

  describe '#path' do
    it 'returns the parent path' do
      expect(@endpoint.path).to eq(@path)
    end
  end

  describe '#method' do
    it 'returns the method as a string' do
      expect(@endpoint.method).to eq('get')
    end
  end

  describe '#description' do
    it 'returns the endpoint description' do
      expect(@endpoint.description).to include('Returns all pets from the system')
    end
  end

  describe '#parameters' do
    it 'returns the endpoint parameters' do
      allow(@path).to receive(:raw) {{ 'parameters' => [{}] }}
      expect(@endpoint.parameters.count).to eq(3)
      expect(@endpoint.parameters[0].class).to eq(OasParser::Parameter)
    end

    context 'when a security schema is present' do
      before do
        @definition = OasParser::Definition.resolve('spec/fixtures/petstore-security-schema.yml')
        @path = @definition.path_by_path('/pets')
        @endpoint = @path.endpoint_by_method('get')
      end

      it 'includes the properties of the security schema' do
        parameters = @endpoint.parameters
        expect(parameters.map(&:name)).to include('api_key')
        expect(parameters.map(&:name)).to include('api_secret')
      end
    end
  end

  describe '#path_parameters' do
    it 'returns the endpoint path_parameters' do
      expect(@endpoint.path_parameters.count).to eq(0)
    end
  end

  describe '#query_parameters' do
    it 'returns the endpoint query_parameters' do
      expect(@endpoint.query_parameters.count).to eq(2)
      expect(@endpoint.query_parameters[0].class).to eq(OasParser::Parameter)
    end
  end

  describe '#responses' do
    it 'returns responses' do
      expect(@endpoint.responses.count).to eq(2)
      expect(@endpoint.responses[0].class).to eq(OasParser::Response)
    end
  end

  describe '#callbacks' do
    it 'returns callbacks' do
      allow(@endpoint).to receive(:raw) { { 'callbacks' => [{}] } }
      expect(@endpoint.callbacks.count).to eq(1)
      expect(@endpoint.callbacks[0].class).to eq(OasParser::Callback)
    end
  end

  describe '#security' do
    it 'returns an empty array when not defined' do
      expect(@endpoint.security).to eq([])
    end

    it 'returns a hash defined' do
      allow(@endpoint).to receive(:security) { [{ 'foo' => [] }] }
      expect(@endpoint.security.flat_map(&:keys)).to include('foo')
    end
  end

  describe '#jwt?' do
    it 'returns a boolean indicating if the endpoint uses JWT authentication' do
      expect(@endpoint.jwt?).to eq(false)
    end

    context 'when the definition provides a security scheme with JWT' do
      before do
        allow(@definition).to receive(:components) { { 'securitySchemes' => { 'foo' => { 'bearerFormat' => 'JWT' } } } }
      end

      it 'returns false when the definition does not subscribe to the security scheme' do
        expect(@endpoint.jwt?).to eq(false)
      end

      context 'definition subscribes to the securitys scheme' do
        it 'returns true' do
          allow(@definition).to receive(:security) { [{ 'foo' => [] }] }
          expect(@endpoint.jwt?).to eq(true)
        end
      end

      context 'endpoint subscribes to the securitys scheme' do
        it 'returns true' do
          allow(@endpoint).to receive(:security) { [{ 'foo' => [] }] }
          expect(@endpoint.jwt?).to eq(true)
        end
      end
    end
  end

  describe '#basic_auth?' do
    it 'returns a boolean indicating if the endpoint uses Basic Auth authentication' do
      expect(@endpoint.basic_auth?).to eq(false)
    end

    context 'when the definition provides a security scheme that is BasicAuth' do
      before do
        allow(@definition).to receive(:components) { { 'securitySchemes' => { 'foo' => { 'type' => 'http', 'scheme' => 'basic' } } } }
      end

      it 'returns false when the definition does not subscribe to the security scheme' do
        expect(@endpoint.basic_auth?).to eq(false)
      end

      context 'definition subscribes to the securitys scheme' do
        it 'returns true' do
          allow(@definition).to receive(:security) { [{ 'foo' => [] }] }
          expect(@endpoint.basic_auth?).to eq(true)
        end
      end

      context 'endpoint subscribes to the securitys scheme' do
        it 'returns true' do
          allow(@endpoint).to receive(:security) { [{ 'foo' => [] }] }
          expect(@endpoint.basic_auth?).to eq(true)
        end
      end
    end
  end

  describe '#security_schemes' do
    it 'returns a boolean indicating if the endpoint uses JWT authentication' do
      expect(@endpoint.security_schemes).to eq([])
    end

    context 'when the definition provides a security scheme with JWT' do
      before do
        allow(@definition).to receive(:components) { { 'securitySchemes' => { 'foo' => { 'bearerFormat' => 'JWT' } } } }
      end

      it 'returns false when the definition does not subscribe to the security scheme' do
        expect(@endpoint.security_schemes).to eq([])
      end

      context 'definition subscribes to the securitys scheme' do
        it 'returns true' do
          allow(@definition).to receive(:security) { [{ 'foo' => [] }] }
          expect(@endpoint.security_schemes.count).to eq(1)
        end
      end

      context 'endpoint subscribes to the securitys scheme' do
        it 'returns true' do
          allow(@endpoint).to receive(:security) { [{ 'foo' => [] }] }
          expect(@endpoint.security_schemes.count).to eq(1)
        end
      end
    end
  end

  describe '#request_body' do
    it 'returns false when there is no request_body' do
      expect(@endpoint.request_body).to be_falsey
    end

    it 'returns a RequestBody when there is a request_body' do
      allow(@endpoint).to receive(:raw) {{ 'requestBody' => {} }}
      expect(@endpoint.request_body.class).to eq(OasParser::RequestBody)
    end
  end

  describe '#response_by_code' do
    it 'allows for an response to be retrived by status code' do
      expect(@endpoint.response_by_code('200').class).to eq(OasParser::Response)
    end

    context 'use default' do
      it 'returns the "default" response if no matching response was found' do
        response = @endpoint.response_by_code('422', use_default: true)
        expect(response.class).to eq(OasParser::Response)
        expect(response.code).to eq('422')
        expect(response.description).to eq('unexpected error')
      end

      it 'returns the matching response' do
        response = @endpoint.response_by_code('200', use_default: true)
        expect(response.class).to eq(OasParser::Response)
        expect(response.code).to eq('200')
      end
    end

    context 'when given an unknown status' do
      it 'raises an exception' do
        expect {
          @endpoint.response_by_code('foo')
        }.to raise_error(OasParser::ResponseCodeNotFound, "Response code not found: 'foo'")
      end
    end
  end

  describe '#parameter_by_name' do
    it 'allows for a parameter to be retrived by name' do
      expect(@endpoint.parameter_by_name('tags').class).to eq(OasParser::Parameter)
    end

    context 'when given an invalid name' do
      it 'raises an exception' do
        expect {
          @endpoint.parameter_by_name('foo')
        }.to raise_error(OasParser::ParameterNotFound, "Parameter not found: 'foo'")
      end
    end
  end

  describe '#callback_by_name' do
    before do
      @definition = OasParser::Definition.resolve('spec/fixtures/callback-example.yml')
      @path = @definition.path_by_path('/streams')
      @endpoint = @path.endpoint_by_method('post')
    end

    it 'allows for a callback to be retrived by name' do
      expect(@endpoint.callback_by_name('onData').class).to eq(OasParser::Callback)
    end

    context 'when given an invalid name' do
      it 'raises an exception' do
        expect {
          @endpoint.callback_by_name('foo')
        }.to raise_error(OasParser::CallbackNotFound, "Callback not found: 'foo'")
      end
    end
  end
end

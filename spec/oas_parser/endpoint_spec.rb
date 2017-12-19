RSpec.describe OasParser::Definition do
  before do
    @definition = OasParser::Definition.resolve('spec/fixtures/petstore-expanded.yml')
    @path = @definition.paths[0]
    @endpoint = @path.endpoints[0]
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
  end

  describe '#responses' do
    it 'returns responses' do
      expect(@endpoint.responses.count).to eq(2)
      expect(@endpoint.responses[0].class).to eq(OasParser::Response)
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
end

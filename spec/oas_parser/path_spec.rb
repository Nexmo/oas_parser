RSpec.describe OasParser::Path do
  before do
    @definition = OasParser::Definition.resolve('spec/fixtures/petstore-expanded.yml')
    @path = @definition.path_by_path('/pets')
  end

  describe '#definition' do
    it 'returns the parent definition' do
      expect(@path.definition).to eq(@definition)
    end
  end

  describe '#path' do
    it 'returns the path' do
      expect(@path.path).to eq('/pets')
    end
  end

  describe '#endpoints' do
    it 'returns the spec endpoints' do
      expect(@path.endpoints.count).to eq(2)
    end

    it 'ignores keys that are not methods' do
      allow(@path).to receive(:raw) {{ 'get' => {}, 'post' => {}, 'parameters' => [{}] }}
      expect(@path.endpoints.count).to eq(2)
    end
  end

  describe '#parameter_keys' do
    it 'ignores keys that are not methods' do
      allow(@path).to receive(:path) { '/pets/{category}/{subcategory}' }
      expect(@path.parameter_keys).to eq(%w[category subcategory])
    end
  end

  describe '#parameters' do
    it 'returns the path parameters' do
      allow(@path).to receive(:raw) {{ 'get' => {}, 'post' => {}, 'parameters' => [{}] }}
      expect(@path.parameters.count).to eq(1)
      expect(@path.parameters[0].class).to eq(OasParser::Parameter)
    end
  end

  describe '#endpoint_by_method' do
    it 'allows for an endpoint to be retrived by its method' do
      expect(@path.endpoint_by_method('get').class).to eq(OasParser::Endpoint)
    end

    context 'when given an invalid method' do
      it 'raises an exception' do
        expect {
          @path.endpoint_by_method('foo')
        }.to raise_error(StandardError, 'So such endpoint exists')
      end
    end
  end
end

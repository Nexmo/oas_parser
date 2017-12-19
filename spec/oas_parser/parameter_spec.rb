RSpec.describe OasParser::Parameter do
  before do
    @definition = OasParser::Definition.resolve('spec/fixtures/petstore-expanded.yml')
    @path = @definition.paths[0]
    @endpoint = @path.endpoints[0]
    @parameter = @endpoint.parameters[0]
  end

  describe '#owner' do
    it 'returns the parent in this case the endpoint' do
      expect(@parameter.owner).to eq(@endpoint)
    end
  end

  describe '#required' do
    it 'returns a boolean' do
      allow(@parameter).to receive(:raw) { { 'required' => true } }
      expect(@parameter.required).to eq(true)

      allow(@parameter).to receive(:raw) { { 'required' => false } }
      expect(@parameter.required).to eq(false)
    end
  end

  describe '#type' do
    it 'returns the parameter type' do
      expect(@parameter.type).to eq('array')
    end
  end

  describe '#array?' do
    context 'when the type is array' do
      it 'returns true' do
        allow(@parameter).to receive(:type) { 'array' }
        expect(@parameter.array?).to eq(true)
      end
    end

    context 'when the type is not array' do
      it 'returns true' do
        allow(@parameter).to receive(:type) { 'foo' }
        expect(@parameter.array?).to eq(false)
      end
    end
  end

  describe '#object?' do
    context 'when the type is object' do
      it 'returns true' do
        allow(@parameter).to receive(:type) { 'object' }
        expect(@parameter.object?).to eq(true)
      end
    end

    context 'when the type is not object' do
      it 'returns true' do
        allow(@parameter).to receive(:type) { 'foo' }
        expect(@parameter.object?).to eq(false)
      end
    end
  end

  describe '#collection?' do
    context 'when the type is array' do
      it 'returns true' do
        allow(@parameter).to receive(:type) { 'object' }
        expect(@parameter.collection?).to eq(true)
      end
    end

    context 'when the type is object' do
      it 'returns true' do
        allow(@parameter).to receive(:type) { 'array' }
        expect(@parameter.collection?).to eq(true)
      end
    end

    context 'when the type is not object' do
      it 'returns true' do
        allow(@parameter).to receive(:type) { 'foo' }
        expect(@parameter.collection?).to eq(false)
      end
    end
  end
end

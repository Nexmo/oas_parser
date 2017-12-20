RSpec.describe OasParser::Property do
  before do
    @definition = OasParser::Definition.resolve('spec/fixtures/petstore-expanded.yml')
    @path = @definition.path_by_path('/pets')
    @endpoint = @path.endpoint_by_method('post')
    @request_body = @endpoint.request_body
    @property = @request_body.properties_for_format('application/json')[0]
  end

  describe '#owner' do
    it 'returns the parent in this case the endpoint' do
      expect(@property.owner).to eq(@request_body)
    end
  end

  describe '#required' do
    it 'returns a boolean' do
      allow(@property).to receive(:name) { 'foo' }
      allow(@property).to receive(:schema) { { 'required' => ['foo'] } }
      expect(@property.required).to eq(true)

      allow(@property).to receive(:schema) { { required: [] } }
      expect(@property.required).to eq(false)
    end
  end

  describe '#type' do
    it 'returns the property type' do
      expect(@property.type).to eq('string')
    end
  end

  describe '#array?' do
    context 'when the type is array' do
      it 'returns true' do
        allow(@property).to receive(:type) { 'array' }
        expect(@property.array?).to eq(true)
      end
    end

    context 'when the type is not array' do
      it 'returns true' do
        allow(@property).to receive(:type) { 'foo' }
        expect(@property.array?).to eq(false)
      end
    end
  end

  describe '#object?' do
    context 'when the type is object' do
      it 'returns true' do
        allow(@property).to receive(:type) { 'object' }
        expect(@property.object?).to eq(true)
      end
    end

    context 'when the type is not object' do
      it 'returns true' do
        allow(@property).to receive(:type) { 'foo' }
        expect(@property.object?).to eq(false)
      end
    end
  end

  describe '#collection?' do
    context 'when the type is array' do
      it 'returns true' do
        allow(@property).to receive(:type) { 'object' }
        expect(@property.collection?).to eq(true)
      end
    end

    context 'when the type is object' do
      it 'returns true' do
        allow(@property).to receive(:type) { 'array' }
        expect(@property.collection?).to eq(true)
      end
    end

    context 'when the type is not object' do
      it 'returns true' do
        allow(@property).to receive(:type) { 'foo' }
        expect(@property.collection?).to eq(false)
      end
    end
  end
end

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
end

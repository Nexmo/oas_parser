RSpec.describe OasParser::Definition do
  before do
    @definition = OasParser::Definition.resolve('spec/fixtures/petstore-expanded.yml')
  end

  it 'parses references from a definition file' do
    expect(@definition.class).to eq(OasParser::Definition)
    expect(@definition.raw.class).to eq(Hash)
  end

  describe '#endpoints' do
    it 'returns the spec paths' do
      expect(@definition.paths.count).to eq(2)
      expect(@definition.paths[0].class).to eq(OasParser::Path)
    end
  end

  describe '#endpoints' do
    it 'returns the spec endpoints' do
      expect(@definition.endpoints.count).to eq(4)
      expect(@definition.endpoints[0].class).to eq(OasParser::Endpoint)
    end
  end

  describe '#servers' do
    it 'returns an array of servers' do
      expect(@definition.servers[0]['url']).to eq('http://petstore.swagger.io/api')
    end
  end

  describe '#info' do
    it 'returns a hash containing information' do
      expect(@definition.info['title']).to eq('Swagger Petstore')
    end
  end

  describe '#openapi' do
    it 'returns the definition version' do
      expect(@definition.openapi).to eq('3.0.0')
    end
  end

  describe '#components' do
    it 'returns the raw components' do
      expect(@definition.components.class).to eq(Hash)
    end
  end

  describe '#security' do
    it 'returns an empty array when not defined' do
      expect(@definition.security).to eq([])
    end

    it 'returns a hash defined' do
      allow(@definition).to receive(:security) { [{ 'foo' => [] }] }
      expect(@definition.security.flat_map(&:keys)).to include('foo')
    end
  end

  describe '#path_by_path' do
    it 'allows for a path to be retrived by its path' do
      expect(@definition.path_by_path('/pets').class).to eq(OasParser::Path)
    end

    it 'finds a path template by path' do
      expect(@definition.path_by_path('/pets/1').class).to eq(OasParser::Path)
    end

    context 'when given an invalid path' do
      it 'raises an exception' do
        expect {
          @definition.path_by_path('/foo')
        }.to raise_error(OasParser::PathNotFound, "Path not found: '/foo'")
      end
    end
  end
end

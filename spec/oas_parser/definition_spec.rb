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
end

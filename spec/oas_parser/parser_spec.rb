RSpec.describe OasParser::Parser do
  it 'parses references from a definition file' do
    definition = OasParser::Parser.resolve('spec/fixtures/petstore-expanded.yml')
    expect(definition.class).to eq(Hash)
  end
  
  it 'parses references from a definition file with external data' do
    definition = OasParser::Parser.resolve('spec/fixtures/petstore-external.yml')
    expect(definition.class).to eq(Hash)
    expect(definition['paths']['/pets']['get']['responses']['200']['schema']['items']['allOf'][0]['properties'].keys).to eq (['id', 'name', 'tag'])
  end
end

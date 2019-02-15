RSpec.describe OasParser::Parser do
  it 'parses references from a definition file' do
    definition = OasParser::Parser.resolve('spec/fixtures/petstore-expanded.yml')
    expect(definition.class).to eq(Hash)
  end

  it 'parses references from a definition file with external data' do
    definition = OasParser::Parser.resolve('spec/fixtures/petstore-remote-reference.yml')

    expect(definition.class).to eq(Hash)

    expect(definition.dig('paths', '/pets', 'get', 'responses', '200', 
                            'content', 'application/json', 'schema', 'items', 'allOf').map {|h| h['properties'].keys }.flatten).to eq (['name', 'tag', 'id'])
  end

end

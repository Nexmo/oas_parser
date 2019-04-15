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

 it 'removes recursive references (Human->Pet->Human)' do
   definition = OasParser::Parser.resolve('spec/fixtures/petstore-recursive.yml')
   r = definition['components']['schemas']['Human']['properties']['pets']
   expect(r['items'].size).to eq 0
 end

  it 'removes self-referencing references' do
    definition = OasParser::Parser.resolve('spec/fixtures/petstore-self-referential.yml')
    r = definition['components']['schemas']['Pet']['properties']['children']
    expect(r['items'][0]).to eq({})
  end

end

RSpec.describe OasParser::Parser do
  it 'parses references from a definition file' do
    definition = OasParser::Parser.resolve('spec/fixtures/petstore-expanded.yml')
    expect(definition.class).to eq(Hash)
  end

  it 'follows JSON pointers in external definitions' do
    definition = OasParser::Parser.resolve('spec/fixtures/petstore-remote-reference.yml')
    expect(definition.dig('paths', '/pets', 'get', 'responses', '200',
                          'content', 'application/json', 'schema', 'items', 'allOf').map {|h| h['properties'].keys }.flatten).to eq (['name', 'tag', 'id'])
  end

  it 'parses references from a definition file with external data' do
    definition = OasParser::Parser.resolve('spec/fixtures/petstore-remote-reference.yml')

    expect(definition.class).to eq(Hash)

    expect(definition.dig('paths', '/pets', 'get', 'responses', '200',
                            'content', 'application/json', 'schema', 'items', 'allOf').map {|h| h['properties'].keys }.flatten).to eq (['name', 'tag', 'id'])
  end

  it 'parses references and stops expanding them if they are circular references' do
    definition = OasParser::Parser.resolve('spec/fixtures/petstore-recursive.yml')
    pets_owners = definition.dig('components', 'schemas', 'Human', 'properties', 'pets', 'items', 0, 'properties', 'owners')

    expect(pets_owners['items']).to eq([{ '$ref' => '#/components/schemas/Human' }])
  end

  it 'parses references and stops expanding them if they are self referential' do
    definition = OasParser::Parser.resolve('spec/fixtures/petstore-self-referential.yml')
    pet_children = definition.dig('components', 'schemas', 'Pet', 'properties', 'children', 'items')

    expect(pet_children).to eq([{ '$ref' => '#/components/schemas/Pet' }])
  end
end

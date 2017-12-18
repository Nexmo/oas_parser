RSpec.describe OasParser::Parser do
  it 'parses references from a definition file' do
    definition = OasParser::Parser.resolve('spec/fixtures/petstore-expanded.yml')
    expect(definition.class).to eq(Hash)
  end
end

RSpec.describe OasParser::Definition do
  before do
    @definition = OasParser::Definition.resolve('spec/fixtures/petstore-expanded.yml')
  end

  it 'parses references from a definition file' do
    expect(@definition.class).to eq(OasParser::Definition)
  end

  it 'parses the info section' do
    expect(@definition.info.class).to eq(OasParser::Info)
  end
end

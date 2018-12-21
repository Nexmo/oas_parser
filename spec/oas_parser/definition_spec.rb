RSpec.describe OasParser::Definition do
  before do
    @definition = OasParser::Definition.resolve('spec/fixtures/petstore-expanded.yml')
  end

  it 'parses references from a definition file' do
    expect(@definition).to be_kind_of(OasParser::Definition)
  end

  it 'parses the info section' do
    expect(@definition.info).to be_kind_of(OasParser::Info)
  end

  it 'parses the servers section' do
    expect(@definition.servers).to be_kind_of(Array)
    expect(@definition.servers[0]).to be_kind_of(OasParser::Server)
  end
end

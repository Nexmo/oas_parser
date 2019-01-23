RSpec.describe OasParser::Server do
  before do
    @server = described_class.new(
      'url' => 'https://example.com',
      'description' => 'This is a server base URL',
      'variables' => {
          'username' => {
              'default' => 'demo'
          }
      }
    )
  end

  it 'raises if required field "url" does not exist' do
    expect { described_class.new({}) }.to raise_error(OasParser::InvalidServerError)
  end

  it 'exposes the url' do
    expect(@server.url).to eq('https://example.com')
  end

  it 'exposes the description' do
    expect(@server.description).to eq('This is a server base URL')
  end

  it 'exposes the variables if provided' do
    expect(@server.variables).to be_kind_of(Hash)
    expect(@server.variables['username']).to be_kind_of(OasParser::ServerVariable)
  end

  it 'provides default values' do
    minimal_server = described_class.new(
        'url' => 'https://example.com'
    )
    expect(minimal_server.description).to eq('')
    expect(minimal_server.variables).to eq({})
  end
end

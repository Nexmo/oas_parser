RSpec.describe OasParser::Info do
  before do
    @info = described_class.new(
      'title' => 'Test OAS',
      'description' => 'This is a demo OAS doc',
      'termsOfService' => 'https://example.com/tos',
      'version' => '1.2.3',
      'contact' => { 'name' => 'Test', 'url' => 'Test', 'email' => 'Test' },
      'license' => { 'name' => 'Test', 'url' => 'Test2' }
    )
  end

  it 'raises if required field "title" does not exist' do
    expect { described_class.new({'version' => '1.2.3'}) }.to raise_error(OasParser::InvalidInfoError)
  end

  it 'raises if required field "version" does not exist' do
    expect { described_class.new({'title' => 'Demo'}) }.to raise_error(OasParser::InvalidInfoError)
  end

  it 'exposes the title' do
    expect(@info.title).to eq('Test OAS')
  end

  it 'exposes the description' do
    expect(@info.description).to eq('This is a demo OAS doc')
  end

  it 'exposes the termsOfService' do
    expect(@info.termsOfService).to eq('https://example.com/tos')
  end

  it 'exposes the version' do
    expect(@info.version).to eq('1.2.3')
  end

  it 'exposes the contact' do
    expect(@info.contact).to be_kind_of(OasParser::Contact)
  end

  it 'exposes the license' do
    expect(@info.license).to be_kind_of(OasParser::License)
  end
end

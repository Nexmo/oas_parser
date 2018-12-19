RSpec.describe OasParser::Contact do
  before do
    @contact = described_class.new(
      'name' => 'Demo Name',
      'url' => 'https://example.com',
      'email' => 'user@example.com'
    )
  end

  it 'exposes the name' do
    expect(@contact.name).to eq('Demo Name')
  end

  it 'exposes the url' do
    expect(@contact.url).to eq('https://example.com')
  end

  it 'exposes the email' do
    expect(@contact.email).to eq('user@example.com')
  end
end

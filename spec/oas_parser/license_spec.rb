RSpec.describe OasParser::License do
  before do
    @license_name = 'MIT'
    @license_url = 'https://opensource.org/licenses/MIT'

    @license = described_class.new(
      'name' => @license_name,
      'url' => @license_url
    )
  end

  it 'raises if required field "name" does not exist' do
    expect { described_class.new({}) }.to raise_error(OasParser::InvalidLicenseError)
  end

  it 'exposes the name' do
    expect(@license.name).to eq(@license_name)
  end

  it 'exposes the url' do
    expect(@license.url).to eq(@license_url)
  end

  it 'has a default url' do
    expect(described_class.new({'name' => 'Demo'}).url).to eq('')
  end

end

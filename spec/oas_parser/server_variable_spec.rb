RSpec.describe OasParser::ServerVariable do
  it 'raises if required field "default" does not exist' do
      expect { described_class.new({}) }.to raise_error(OasParser::InvalidServerVariableError)
  end

  it 'persists all provided values' do
    server_variable = described_class.new({
            'default' => 'demo',
            'enum' => ['annie', 'bob'],
            'description' => 'This one has a limited set of usernames'
        } );
    expect(server_variable.default).to eq('demo')
    expect(server_variable.enum).to eq(['annie', 'bob'])
    expect(server_variable.description).to eq('This one has a limited set of usernames')
  end

  it 'sets smart defaults' do
    server_variable = described_class.new(
        {
            'default' => 'demo'
        } );
    expect(server_variable.default).to eq('demo')
    expect(server_variable.enum).to eq(nil)
    expect(server_variable.description).to eq('')
  end
end

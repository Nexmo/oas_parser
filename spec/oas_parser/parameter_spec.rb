RSpec.describe OasParser::Parameter do
  it 'persists all provided values' do
    parameter = described_class.new(
      'name' => 'demo',
      'in' => 'query',
      'description' => 'Demo Description',
      'required' => false,
      'deprecated' => false,
      'allowEmptyValue' => true
    )
    expect(parameter.name).to eq('demo')
    expect(parameter.in).to eq('query')
    expect(parameter.description).to eq('Demo Description')
    expect(parameter.required).to eq(false)
    expect(parameter.deprecated).to eq(false)
    expect(parameter.allow_empty_value).to eq(true)
  end
end

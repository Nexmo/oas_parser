RSpec.describe OasParser::Operation do
  before do
    @operation = described_class.new(
      'tags' => %w[one two],
      'summary' => 'This is a summary',
      'description' => 'This is a description',
      'operationId' => 'makeCall',
      'deprecated' => false,
      'servers' => [{ 'url' => 'https://operation.example.com' }],
      'responses' => {
        200 => {
          'description' => 'Successful Request'
        }
      },
      'externalDocs' => {
        'url' => 'https://example.com'
      },
      'requestBody' => {
        'content' => {
          'application/json' => {}
        }
      },
      'callbacks' => {
          'test_callback' => {
              '/foo' => {
                  'post' => {
                      'responses' => {
                          '200' => {
                              'description' => 'Successful Request'
                          }
                      }
                  },
              }
          }
      },
      'security' => {
          'petstore_auth' => [
              'pets:write'
          ]
      }
    )
  end

  it 'raises if required field "responses" does not exist' do
    expect { described_class.new({}) }.to raise_error(OasParser::InvalidOperationError)
  end

  it 'exposes responses' do
    expect(@operation.responses).to be_kind_of(Hash)
    expect(@operation.responses[200]).to be_kind_of(OasParser::Response)
  end

  it 'exposes tags' do
    expect(@operation.tags).to eq(%w[one two])
  end

  it 'exposes summary' do
    expect(@operation.summary).to eq('This is a summary')
  end

  it 'exposes description' do
    expect(@operation.description).to eq('This is a description')
  end

  it 'exposes operation_id' do
    expect(@operation.operation_id).to eq('makeCall')
  end

  it 'exposes deprecated' do
    expect(@operation.deprecated).to eq(false)
  end

  it 'exposes external_docs' do
    expect(@operation.external_docs).to be_kind_of(OasParser::ExternalDocs)
  end

  it 'exposes request_body' do
    expect(@operation.request_body).to be_kind_of(OasParser::RequestBody)
  end

  it 'exposes servers' do
    expect(@operation.servers).to be_kind_of(Array)
    expect(@operation.servers[0]).to be_kind_of(OasParser::Server)
  end

  it 'exposes callbacks' do
    expect(@operation.callbacks).to be_kind_of(Hash)
    expect(@operation.callbacks['test_callback']).to be_kind_of(OasParser::PathItem)
  end

  it 'exposes security' do
    expect(@operation.security).to be_kind_of(Hash)
    expect(@operation.security['petstore_auth']).to be_kind_of(Array)
    expect(@operation.security['petstore_auth'][0]).to eql('pets:write')
  end
end

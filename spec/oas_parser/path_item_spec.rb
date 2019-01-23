RSpec.describe OasParser::PathItem do
  before do
    @path_item = described_class.new(
      'summary' => 'This is a summary',
      'description' => 'This is a description',
      'get' => {
        'responses' => {
          '200' => {
            'description' => 'Successful Request'
          }
        }
      },
      'put' => {
        'responses' => {
          '200' => {
            'description' => 'Successful Request'
          }
        }
      },
      'post' => {
        'responses' => {
          '200' => {
            'description' => 'Successful Request'
          }
        }
      },
      'delete' => {
        'responses' => {
          '200' => {
            'description' => 'Successful Request'
          }
        }
      },
      'options' => {
        'responses' => {
          '200' => {
            'description' => 'Successful Request'
          }
        }
      },
      'head' => {
        'responses' => {
          '200' => {
            'description' => 'Successful Request'
          }
        }
      },
      'patch' => {
        'responses' => {
          '200' => {
            'description' => 'Successful Request'
          }
        }
      },
      'trace' => {
        'responses' => {
          '200' => {
            'description' => 'Successful Request'
          }
        }
      },
      'servers' => [
        { 'url' => 'https://path-item-server.example.com' }
      ],
      'parameters' => [
        { 'name' => 'test', 'in' => 'query' }
      ]
    )
  end

  it 'exposes the summary' do
    expect(@path_item.summary).to eq('This is a summary')
  end

  it 'exposes the description' do
    expect(@path_item.description).to eq('This is a description')
  end

  it 'exposes get' do
    expect(@path_item.get).to be_kind_of(OasParser::Operation)
  end

  it 'exposes put' do
    expect(@path_item.post).to be_kind_of(OasParser::Operation)
  end

  it 'exposes post' do
    expect(@path_item.post).to be_kind_of(OasParser::Operation)
  end

  it 'exposes post' do
    expect(@path_item.post).to be_kind_of(OasParser::Operation)
  end

  it 'exposes delete' do
    expect(@path_item.delete).to be_kind_of(OasParser::Operation)
  end

  it 'exposes options' do
    expect(@path_item.options).to be_kind_of(OasParser::Operation)
  end

  it 'exposes head' do
    expect(@path_item.head).to be_kind_of(OasParser::Operation)
  end

  it 'exposes patch' do
    expect(@path_item.patch).to be_kind_of(OasParser::Operation)
  end

  it 'exposes trace' do
    expect(@path_item.trace).to be_kind_of(OasParser::Operation)
  end

  it 'exposes servers' do
    expect(@path_item.servers).to be_kind_of(Array)
    expect(@path_item.servers[0]).to be_kind_of(OasParser::Server)
  end

  it 'exposes parameters' do
    expect(@path_item.parameters).to be_kind_of(Hash)
    # TODO: Inspect one of the params
  end
end

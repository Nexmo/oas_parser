RSpec.describe OasParser::RequestBody do
  before do
    @definition = OasParser::Definition.resolve('spec/fixtures/petstore-expanded.yml')
    @path = @definition.paths[0]
    @endpoint = @path.endpoints[1]
    @request_body = @endpoint.request_body
  end

  describe '#description' do
    it 'returns the description of the response' do
      expect(@request_body.description).to eq('Pet to add to the store')
    end
  end

  describe '#formats' do
    it 'returns the available response formats' do
      expect(@request_body.formats).to eq(['application/json'])
    end
  end
end

RSpec.describe OasParser::Response do
  before do
    @definition = OasParser::Definition.resolve('spec/fixtures/petstore-expanded.yml')
    @path = @definition.paths[0]
    @endpoint = @path.endpoints[0]
    @response = @endpoint.responses[0]
  end

  describe '#code' do
    it 'returns the status code of the response' do
      expect(@response.code).to eq('200')
    end
  end
end

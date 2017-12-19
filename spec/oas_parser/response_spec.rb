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

  describe '#description' do
    it 'returns the description of the response' do
      expect(@response.description).to eq('pet response')
    end
  end

  describe '#formats' do
    it 'returns the available response formats' do
      expect(@response.formats).to eq(['application/json'])
    end
  end

  describe '#success?' do
    it 'returns true only for 200 status codes' do
      allow(@response).to receive(:code) { '200' }
      expect(@response.success?).to eq(true)

      allow(@response).to receive(:code) { '201' }
      expect(@response.success?).to eq(true)

      allow(@response).to receive(:code) { '2xx' }
      expect(@response.success?).to eq(false)

      allow(@response).to receive(:code) { '300' }
      expect(@response.success?).to eq(false)
    end
  end
end

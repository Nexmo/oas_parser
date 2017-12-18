RSpec.describe OasParser::Definition do
  before do
    @definition = OasParser::Definition.resolve('spec/fixtures/petstore-expanded.yml')
    @path = @definition.paths[0]
    @endpoint = @path.endpoints[0]
    @parameters = @endpoint.parameters[0]
  end

  describe '#owner' do
    it 'returns the parent in this case the endpoint' do
      expect(@parameters.owner).to eq(@endpoint)
    end
  end

  describe '#required' do
    it 'returns a boolean' do
      expect([true, false]).to include()
    end

    context 'when the owner provides a key of required with the name' do
      it 'returns true' do
        allow(@parameters).to receive(:name) { 'page' }
        allow(@endpoint).to receive(:required) { ['page'] }
        expect(@parameters.required).to eq(true)
      end
    end
  end
end

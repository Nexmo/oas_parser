RSpec.describe OasParser::Response do
  before do
    @definition = OasParser::Definition.resolve('spec/fixtures/petstore-expanded.yml')
    @path = @definition.path_by_path('/pets')
    @endpoint = @path.endpoint_by_method('get')
    @response = @endpoint.response_by_code('200')
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

  describe '#exhibits_one_of_multiple_schemas?' do
    it 'returns false for the petstore definition' do
      expect(@response.exhibits_one_of_multiple_schemas?).to eq(false)
    end
  end

  describe '#schema' do
    it 'returns the schema for the given format' do
      expect(@response.schema('application/json')['type']).to eq('array')
    end
  end

  context 'given a definition that provides oneOf as a response' do
    before do
      @definition = OasParser::Definition.resolve('spec/fixtures/petstore-oneof.yml')
      @path = @definition.path_by_path('/random')
      @endpoint = @path.endpoint_by_method('get')
      @response = @endpoint.response_by_code('200')
    end

    describe '#exhibits_one_of_multiple_schemas?' do
      it 'returns true' do
        expect(@response.exhibits_one_of_multiple_schemas?).to eq(true)
      end
    end

    describe '#split_schemas' do
      it 'returns all schemas' do
        expect(@response.split_schemas('application/json').count).to eq(2)
      end
    end
  end
end

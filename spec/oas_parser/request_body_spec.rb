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

  describe '#schema' do
    it 'returns the requested schema' do
      expect(@request_body.schema('application/json').keys).to include('properties')
    end
  end

  describe '#properties_for_format' do
    it 'returns an array of properties' do
      subject = @request_body.properties_for_format('application/json')
      expect(subject.class).to eq(Array)
      expect(subject[0].class).to eq(OasParser::Property)
    end
  end
end

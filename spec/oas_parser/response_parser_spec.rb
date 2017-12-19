RSpec.describe OasParser::ResponseParser do
  before do
    @definition = OasParser::Definition.resolve('spec/fixtures/petstore-expanded.yml')

    @index_path = @definition.paths[0]
    @index_endpoint = @index_path.endpoints[0]
    @index_response = @index_endpoint.responses[0]
    @index_schema = @index_response.schema('application/json')

    @create_path = @definition.paths[1]
    @create_endpoint = @create_path.endpoints[0]
    @create_response = @create_endpoint.responses[0]
    @create_schema = @create_response.schema('application/json')
  end

  describe '#parse' do
    context 'for array responses' do
      it 'returns a parsed response' do
        response = OasParser::ResponseParser.new(@index_schema).parse
        expect(response.class).to eq(Array)
        expect(response[0].keys).to include('name')
        expect(response[0].keys).to include('tag')
        expect(response[0].keys).to include('id')
      end
    end

    context 'for object responses' do
      it 'returns a parsed response' do
        response = OasParser::ResponseParser.new(@create_schema).parse
        expect(response.class).to eq(Hash)
        expect(response.keys).to include('name')
        expect(response.keys).to include('tag')
        expect(response.keys).to include('id')
      end
    end
  end
end

RSpec.describe OasParser::Parameter do
  before do
    @definition = OasParser::Definition.resolve('spec/fixtures/petstore-parameter-oneof-allof.yml')
    @path = @definition.path_by_path('/pets')
    @endpoint = @path.endpoint_by_method('post')
    @request_body = @endpoint.request_body
    @property = @request_body.properties_for_format('application/json')[0]
  end

  describe '#name' do
    it 'returns the parameter name' do
      expect(@property.name).to eq('details')
    end

    it 'returns all possible parameter definitions' do
      expect(@property.properties).to have(2).items
    end

    it 'returns items in the defined order' do
      # The first oneOf details option is age + realname
      expect(@property.properties[0]['properties'][0].name).to eq('age')
      expect(@property.properties[0]['properties'][1].name).to eq('realname')

      # The second oneOf details option is age + nickname
      expect(@property.properties[1]['properties'][0].name).to eq('age')
      expect(@property.properties[1]['properties'][1].name).to eq('nickname')
    end

    it 'provides a complete "property" object' do
      age = @property.properties[0]['properties'][0]
      expect(age.name).to eq('age')
      expect(age.example).to eq(12)
      expect(age.description).to eq("How old's your dog?")
    end
  end
end

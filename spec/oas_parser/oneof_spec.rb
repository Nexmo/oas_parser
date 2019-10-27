RSpec.describe OasParser::Parameter do
  before do
    @definition = OasParser::Definition.resolve('spec/fixtures/petstore-parameter-oneof.yml')
    @path = @definition.path_by_path('/pets')
    @endpoint = @path.endpoint_by_method('post')
    @request_body = @endpoint.request_body
    @property = @request_body.properties_for_format('application/json')[0]
  end

  describe '#name' do
    it 'returns the parameter name' do
      expect(@property.name).to eq('name')
    end

    it 'returns all possible parameter definitions' do
      expect(@property.properties).to have(2).items
    end

    it 'returns items in the defined order' do
      expect(@property.properties[0]['properties'][0].name).to eq('realname')
      expect(@property.properties[1]['properties'][0].name).to eq('nickname')
    end

    it 'provides a complete "property" object' do
      realname = @property.properties[0]['properties'][0]
      expect(realname.name).to eq('realname')
      expect(realname.example).to eq('Fido')
      expect(realname.description).to eq("What's your dog's real name?")
    end
  end

  describe '#required' do
    before do
      @definition = OasParser::Definition.resolve('spec/fixtures/reports.yml')
      @path = @definition.path_by_path('/v2/reports')
      @endpoint = @path.endpoint_by_method('post')
      @request_body = @endpoint.request_body
      @properties = @request_body.split_properties_for_format('application/json')[1]
      @product_property = @properties[0]
      @account_property = @properties[1]
      @date_start_property = @properties[2]
    end

    it 'handles required fields in a request body' do
      expect(@product_property.required).to be(true)
      expect(@account_property.required).to be(true)
      expect(@date_start_property.required).to be(false)
    end
  end
end

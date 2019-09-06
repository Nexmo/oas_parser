RSpec.describe OasParser::Parameter do
  before do
    @definition = OasParser::Definition.resolve('spec/fixtures/petstore-expanded.yml')
    @path = @definition.path_by_path('/pets')
    @endpoint = @path.endpoint_by_method('get')
    @parameter = @endpoint.parameter_by_name('tags')
  end

  describe '#name' do
    it 'returns the parameter name' do
      expect(@parameter.name).to eq('tags')
    end
  end

  describe '#owner' do
    it 'returns the parent in this case the endpoint' do
      expect(@parameter.owner).to eq(@endpoint)
    end
  end

  describe '#required' do
    it 'returns a boolean' do
      allow(@parameter).to receive(:raw) { { 'required' => true } }
      expect(@parameter.required).to eq(true)

      allow(@parameter).to receive(:raw) { { 'required' => false } }
      expect(@parameter.required).to eq(false)
    end
  end

  describe '#type' do
    it 'returns the parameter type' do
      expect(@parameter.type).to eq('array')
    end
  end

  describe '#array?' do
    context 'when the type is array' do
      it 'returns true' do
        allow(@parameter).to receive(:type) { 'array' }
        expect(@parameter.array?).to eq(true)
      end
    end

    context 'when the type is not array' do
      it 'returns true' do
        allow(@parameter).to receive(:type) { 'foo' }
        expect(@parameter.array?).to eq(false)
      end
    end
  end

  describe '#object?' do
    context 'when the type is object' do
      it 'returns true' do
        allow(@parameter).to receive(:type) { 'object' }
        expect(@parameter.object?).to eq(true)
      end
    end

    context 'when the type is not object' do
      it 'returns true' do
        allow(@parameter).to receive(:type) { 'foo' }
        expect(@parameter.object?).to eq(false)
      end
    end
  end

  describe '#collection?' do
    context 'when the type is array' do
      it 'returns true' do
        allow(@parameter).to receive(:type) { 'object' }
        expect(@parameter.collection?).to eq(true)
      end
    end

    context 'when the type is object' do
      it 'returns true' do
        allow(@parameter).to receive(:type) { 'array' }
        expect(@parameter.collection?).to eq(true)
      end
    end

    context 'when the type is not object' do
      it 'returns true' do
        allow(@parameter).to receive(:type) { 'foo' }
        expect(@parameter.collection?).to eq(false)
      end
    end
  end

  describe 'oneOf / allOf handling' do
    # This checks for instances where a single parameter in a request/response is a oneOf that contains an allOf
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
end

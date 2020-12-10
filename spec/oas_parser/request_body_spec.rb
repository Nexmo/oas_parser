RSpec.describe OasParser::RequestBody do
  before do
    @definition = OasParser::Definition.resolve('spec/fixtures/petstore-expanded.yml')
    @path = @definition.path_by_path('/pets')
    @endpoint = @path.endpoint_by_method('post')
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

  describe 'oneOf / allOf handling' do
    # This checks for instances where an entire request body is a oneOf that contains an allOf
    before do
      @definition = OasParser::Definition.resolve('spec/fixtures/reports.yml')
      @path = @definition.path_by_path('/v2/reports')
      @endpoint = @path.endpoint_by_method('post')
      @request_body = @endpoint.request_body
      @schemas = @request_body.split_properties_for_format('application/json')
      @sms_properties = @schemas[0]
      @voice_properties = @schemas[1]
    end

    it 'returns all items in oneOf that are not an allOf (sms)' do
      expect(@sms_properties[0].name).to eq('direction')
      expect(@sms_properties[1].name).to eq('status')
      expect(@sms_properties[2].name).to eq('client_ref')
      expect(@sms_properties[3].name).to eq('account_ref')
    end

    it 'returns all items in oneOf that are an allOf (voice)' do
      expect(@voice_properties[0].name).to eq('product')
      expect(@voice_properties[1].name).to eq('account_id')
      expect(@voice_properties[2].name).to eq('date_start')
      expect(@voice_properties[3].name).to eq('date_end')
      expect(@voice_properties[4].name).to eq('include_subaccounts')
      expect(@voice_properties[5].name).to eq('callback_url')
      expect(@voice_properties[6].name).to eq('direction')
      expect(@voice_properties[7].name).to eq('to')
      expect(@voice_properties[8].name).to eq('from')
      expect(@voice_properties[9].name).to eq('status')
    end

  end

  describe 'allOf recursive' do
    before do
      @definition = OasParser::Definition.resolve('spec/fixtures/petstore-recursive-allof.yml')
      @path = @definition.path_by_path('/pet')
      @endpoint = @path.endpoint_by_method('post')
      @request_body = @endpoint.request_body
      @properties = @request_body.properties_for_format('application/json')
    end

    it 'handles multi-depth allOf values' do
      expect(@properties[0].name).to eq('name')
      expect(@properties[1].name).to eq('price')
      expect(@properties[2].name).to eq('age')
    end

    it 'merges required list' do
      expect(@properties[0].required).to eq(true)
      expect(@properties[1].required).to eq(true)
    end

  end


end

RSpec.describe OasParser::Callback do
  before do
    @definition = OasParser::Definition.resolve('spec/fixtures/callback-example.yml')
    @path = @definition.path_by_path('/streams')
    @endpoint = @path.endpoint_by_method('post')
    @callback = @endpoint.callback_by_name('onData')
  end

  describe '#name' do
    it 'returns the name of the callback' do
      expect(@callback.name).to eq('onData')
    end
  end

  describe '#paths' do
    it 'returns the name of the callback' do
      expect(@callback.paths.count).to eq(1)
      expect(@callback.paths[0].class).to eq(OasParser::Path)
    end
  end
end

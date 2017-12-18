RSpec.describe OasParser::Path do
  before do
    @definition = OasParser::Definition.resolve('spec/fixtures/petstore-expanded.yml')
    @path = @definition.paths[0]
  end

  describe '#definition' do
    it 'returns the parent definition' do
      expect(@path.definition).to eq(@definition)
    end
  end

  describe '#path' do
    it 'returns the path' do
      expect(@path.path).to eq('/pets')
    end
  end

  describe '#endpoints' do
    it 'returns the spec endpoints' do
      expect(@path.endpoints.count).to eq(2)
    end

    it 'ignores keys that are not methods' do
      allow(@path).to receive(:raw) {{ 'get' => {}, 'post' => {}, 'parameters' => {} }}
      expect(@path.endpoints.count).to eq(2)
    end
  end

  describe '#parameter_keys' do
    it 'ignores keys that are not methods' do
      allow(@path).to receive(:path) { '/pets/{category}/{subcategory}' }
      expect(@path.parameter_keys).to eq(%w[category subcategory])
    end
  end
end

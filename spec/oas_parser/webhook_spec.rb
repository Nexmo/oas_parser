# frozen_string_literal: true

RSpec.describe OasParser::Webhook do
  before do
    @definition = OasParser::Definition.resolve('spec/fixtures/petstore-webhooks.yml')
    @webhook = @definition.webhooks[0]
  end

  describe '#name' do
    it 'returns the webhook name' do
      expect(@webhook.name).to eq('newPet')
    end
  end

  describe '#definition' do
    it 'returns the parent definition' do
      expect(@webhook.definition).to eq(@definition)
    end
  end

  describe '#path' do
    it 'returns the name when path is called' do
      expect(@webhook.path).to eq('newPet')
    end
  end

  describe '#endpoints' do
    it 'returns the spec endpoints' do
      expect(@webhook.endpoints.count).to eq(1)
    end

    it 'ignores keys that are not methods' do
      allow(@webhook).to receive(:raw) { { 'get' => {}, 'post' => {}, 'parameters' => [{}] } }
      expect(@webhook.endpoints.count).to eq(2)
    end
  end

  describe '#parameter_keys' do
    it 'ignores keys that are not methods' do
      allow(@webhook).to receive(:path) { '/pets/{category}/{subcategory}' }
      expect(@webhook.parameter_keys).to eq(%w[category subcategory])
    end
  end

  describe '#parameters' do
    it 'returns the path parameters' do
      allow(@webhook).to receive(:raw) { { 'get' => {}, 'post' => {}, 'parameters' => [{}] } }
      expect(@webhook.parameters.count).to eq(1)
      expect(@webhook.parameters[0].class).to eq(OasParser::Parameter)
    end
  end

  describe '#endpoint_by_method' do
    it 'allows for an endpoint to be retrived by its method' do
      expect(@webhook.endpoint_by_method('post').class).to eq(OasParser::Endpoint)
    end

    context 'when given an invalid method' do
      it 'raises an exception' do
        expect do
          @webhook.endpoint_by_method('foo')
        end.to raise_error(OasParser::MethodNotFound, "HTTP method not found: 'foo'")
      end
    end
  end
end

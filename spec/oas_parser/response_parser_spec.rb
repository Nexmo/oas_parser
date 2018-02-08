RSpec.describe OasParser::ResponseParser do
  before do
    @definition = OasParser::Definition.resolve('spec/fixtures/petstore-expanded.yml')

    @index_path = @definition.path_by_path('/pets')
    @index_endpoint = @index_path.endpoint_by_method('get')
    @index_response = @index_endpoint.response_by_code('200')
    @index_schema = @index_response.schema('application/json')

    @create_path = @definition.paths[1]
    @create_endpoint = @create_path.endpoints[0]
    @create_response = @create_endpoint.responses[0]
    @create_schema = @create_response.schema('application/json')

    @schema = {
      'type' => 'object',
      'properties' => {
        'number' => {
          'type' => 'number'
        },
        'street_name' => {
          'type' => 'string',
          'example' => '1 Infinite Loop'
        },
        'street_type' => {
          'type' => 'string',
          'enum' => ['Street', 'Avenue', 'Boulevard']
        }
      }
    }
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

      it 'returns handles examples' do
        response = OasParser::ResponseParser.new(@schema).parse

        expect(response).to eq({
          'number' => 1.0,
          'street_name' => '1 Infinite Loop',
          'street_type' => 'abc123'
        })
      end
    end
  end

  describe 'json' do
    it 'returns JSON' do
      response = OasParser::ResponseParser.new(@schema).json

      expected_response = <<~HEREDOC
        {
          "number": 1.0,
          "street_name": "1 Infinite Loop",
          "street_type": "abc123"
        }
      HEREDOC

      expect(response).to eq(JSON.parse(expected_response).to_json)
    end
  end

  describe 'xml' do
    it 'returns XML' do
      response = OasParser::ResponseParser.new(@schema).xml

      expected_response = <<~HEREDOC
        <?xml version="1.0" encoding="UTF-8"?>
        <hash>
          <number>1.0</number>
          <street_name>1 Infinite Loop</street_name>
          <street_type>abc123</street_type>
        </hash>
      HEREDOC

      expect(response).to eq(expected_response)
    end
  end

  context 'when the schema has XML attributes' do
    before do
      @schema = {
        'type' => 'object',
        'properties' => {
          'code' => {
            'type' => 'integer',
            'xml' => {
              'attribute' => true
            }
          },
          'foo' => {
            'type' => 'object',
            'properties' => {
              'foo' => {
                'type' => 'integer',
                'xml' => {
                  'attribute' => true
                }
              },
            }
          }
        }
      }
    end

    describe 'xml' do
      it 'includes them as XML attributes' do
        response = OasParser::ResponseParser.new(@schema).xml

        expected_response = <<~HEREDOC
          <?xml version="1.0" encoding="UTF-8"?>
          <hash code="1">
            <foo foo="1">
            </foo>
          </hash>
        HEREDOC

        expect(response).to eq(expected_response)
      end
    end

    describe 'json' do
      it 'ignores the attributes' do
        response = OasParser::ResponseParser.new(@schema).json

        expected_response = <<~HEREDOC
          {
            "code": 1,
            "foo": {
              "foo": 1
            }
          }
        HEREDOC

        expect(response).to eq(JSON.parse(expected_response).to_json)
      end
    end
  end

  context 'when the schema has XML attributes on an array type' do
    before do
      @schema = {
        "type" => "object",
        "properties" => {
          "items" => {
            "type" => "array",
            "xml" => {
              "name" => "items"
            },
            "items" => {
              "properties" => {
                "foo" => {
                  "type" => "string"
                }
              }
            },
            "properties" => {
              "quantity" => {
                "type" => "integer",
                "example" => 1,
                "xml" => {
                  'attribute' => true
                }
              }
            }
          }
        }
      }
    end

    describe 'xml' do
      it 'includes them as XML attributes' do
        response = OasParser::ResponseParser.new(@schema).xml

        expected_response = <<~HEREDOC
          <?xml version="1.0" encoding="UTF-8"?>
          <hash>
            <items quantity="1">
              <item>
                <foo>abc123</foo>
              </item>
            </items>
          </hash>
        HEREDOC

        expect(response).to eq(expected_response)
      end
    end

    describe 'json' do
      it 'ignores the attributes' do
        response = OasParser::ResponseParser.new(@schema).json

        expected_response = <<~HEREDOC
          {
            "items": [
              {
                "foo": "abc123"
              }
            ]
          }
        HEREDOC

        expect(response).to eq(JSON.parse(expected_response).to_json)
      end
    end
  end

  context 'when the schema has XML text' do
    before do
      @schema = {
        'type' => 'object',
        'properties' => {
          'foo' => {
            'type' => 'object',
            'properties' => {
              'bar' => {
                'type' => 'string',
                'xml' => {
                  'text' => true
                }
              },
            }
          }
        }
      }
    end

    describe 'xml' do
      it 'does not wrap the value in a property node' do
        response = OasParser::ResponseParser.new(@schema).xml

        expected_response = <<~HEREDOC
          <?xml version="1.0" encoding="UTF-8"?>
          <hash>
            <foo>abc123</foo>
          </hash>
        HEREDOC

        expect(response).to eq(expected_response)
      end
    end

    describe 'json' do
      it 'ignores the xml text flag' do
        response = OasParser::ResponseParser.new(@schema).json

        expected_response = <<~HEREDOC
          {
            "foo": {
              "bar": "abc123"
            }
          }
        HEREDOC

        expect(response).to eq(JSON.parse(expected_response).to_json)
      end
    end
  end


  context 'when the schema has XML name' do
    before do
      @schema = {
        'type' => 'object',
        'properties' => {
          'foo_bar' => {
            'type' => 'string',
            'xml' => {
              'name' => 'fooBar'
            }
          }
        }
      }
    end

    describe 'xml' do
      it 'uses the name value as the node' do
        response = OasParser::ResponseParser.new(@schema).xml

        expected_response = <<~HEREDOC
          <?xml version="1.0" encoding="UTF-8"?>
          <hash>
            <fooBar>abc123</fooBar>
          </hash>
        HEREDOC

        expect(response).to eq(expected_response)
      end
    end

    describe 'json' do
      it 'ignores the xml name flag' do
        response = OasParser::ResponseParser.new(@schema).json

        expected_response = <<~HEREDOC
          {
            "foo_bar": "abc123"
          }
        HEREDOC

        expect(response).to eq(JSON.parse(expected_response).to_json)
      end
    end
  end
end

# Open API Definition Parser

A Ruby parser for Open API Spec 3.0+ definitions.

### Install

Install the gem:

```
$ gem install oas_parser
```

Or add it to your Gemfile:

```ruby
gem 'oas_parser'
```

### Usage

Here is a basic example of how you can traverse through an Open API Spec 3 Definition:

```ruby
require 'oas_parser'

definition = OasParser::Definition.resolve('petstore.yml')
# => #<OasParser::Definition>

# Get a specific path
path = definition.path_by_path('/pets')
# => #<OasParser::Path>

# Get all paths.
definition.paths
# => [#<OasParser::Path>, ...]

# Get a specific endpoint by method
endpoint = path.endpoint_by_method('get')
# => #<OasParser::Endpoint>

# Get all endpoints
path.endpoints
# => [#<OasParser::Endpoint>, ...]

# Get endpoint description
endpoint.description
# => "Returns all pets from the system that the user has access to"
```

Checkout the tests and `lib` directory for more classes and methods.

### Development

Run tests:

```
$ rspec
```

## Contributing

Contributions are welcome, please follow [GitHub Flow](https://guides.github.com/introduction/flow/index.html)

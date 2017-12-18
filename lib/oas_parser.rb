require 'json'
require 'uri'
require 'yaml'

require 'addressable/uri'
require 'json_schema'

require './lib/oas_parser/raw_accessor.rb'

Dir['./lib/oas_parser/**/*.rb'].each { |file| require file }

module OasParser
  # Your code goes here...
end

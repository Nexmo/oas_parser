require 'json'
require 'uri'
require 'yaml'

require 'addressable/uri'
require 'json_schema'
require 'deep_merge'

require_relative 'oas_parser/payload.rb'
require_relative 'oas_parser/raw_accessor.rb'

Dir["#{File.dirname(__FILE__)}/oas_parser/**/*.rb"].each do |file|
  require file
end

File.expand_path('path', File.dirname(__FILE__))

module OasParser
  # Your code goes here...
end

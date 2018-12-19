require 'json'
require 'uri'
require 'yaml'
require 'active_support/core_ext/object/blank'
require 'active_support/core_ext/hash/conversions'
require 'nokogiri'

require 'addressable/uri'
require 'deep_merge'

Dir["#{File.dirname(__FILE__)}/oas_parser/**/*.rb"].each do |file|
  require file
end

File.expand_path('path', File.dirname(__FILE__))

module OasParser
  # Your code goes here...
end

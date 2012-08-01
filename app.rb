APP_DIR = File.expand_path File.dirname(__FILE__)

require 'rubygems'
require 'bundler'
require 'open-uri'
Bundler.require

['parser.rb', 'cache.rb'].each {|file| require File.join(APP_DIR, file) }

Bixi::Cache.expiry = 5

def fetch_json
  data = open('https://montreal.bixi.com/maps/statajax').read
  parser = Bixi::Parser.new(data)
  JSON.dump parser.stations
end

get '/' do
  content_type :json
  Bixi::Cache[:stations] ||= fetch_json
end
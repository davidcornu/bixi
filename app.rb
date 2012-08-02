# encoding=utf-8

require 'rubygems'
require 'bundler'
require 'open-uri'
Bundler.require

APP_DIR = File.expand_path File.dirname(__FILE__)
['parser.rb', 'cache.rb'].each {|file| require File.join(APP_DIR, file) }

module Bixi
  class App < Sinatra::Base
    VALID_CITIES = ['montreal', 'toronto', 'ottawa']

    before do
      content_type :json
    end

    get '/:city' do
      if VALID_CITIES.include?(params[:city])
        Bixi::Cache[params[:city]] ||= fetch_json(params[:city])
      else
        pass
      end
    end

    get '*' do
      status 404
      JSON.dump :supported_paths => ['/montreal', '/toronto', '/ottawa']
    end

    private

    def bixi_url(city)
      subdomains = {
        'montreal' => 'montreal',
        'toronto'  => 'toronto',
        'ottawa'   => 'capitale'
      }
      return "https://#{subdomains[city]}.bixi.com/maps/statajax"
    end

    def fetch_json(city)
      begin
        data = open(bixi_url(city)).read
        parser = Bixi::Parser.new(data)
        JSON.dump parser.stations
      rescue OpenURI::HTTPError
        JSON.dump :error => "Data not currently available for #{city.capitalize}"
      end
    end
  end
end
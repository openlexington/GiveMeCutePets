#!/usr/bin/env ruby
 
require 'twitter'
require 'dotenv'
Dotenv.load

config = {
  consumer_key:        ENV['api_key'],
  consumer_secret:     ENV['api_secret'],
  access_token:        ENV['access_token'],
  access_token_secret: ENV['access_token_secret']
}

rClient = Twitter::REST::Client.new config
 
rClient.update("a third test")
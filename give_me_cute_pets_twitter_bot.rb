#!/usr/bin/env ruby
 
require 'twitter'
require 'dotenv'
require './lib/cute_pets'
Dotenv.load

config = {
  consumer_key:        ENV['api_key'],
  consumer_secret:     ENV['api_secret'],
  access_token:        ENV['access_token'],
  access_token_secret: ENV['access_token_secret']
}

while true

  rClient = Twitter::REST::Client.new config
  sClient = Twitter::Streaming::Client.new config

  sClient.user do |object|
    case object
    when Twitter::Tweet
      begin
        zip = object.full_text.split(' ')[1]
        tweet_id = object.id
        CutePets.post_pet(zip, tweet_id)
      rescue
        sleep 10
      end
    end
  end
end
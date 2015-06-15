require 'tweetstream'

TweetStream.configure do |config|
  config.consumer_key       = ENV['api_key']
  config.consumer_secret    = ENV['api_secret']
  config.oauth_token        = ENV['access_token']
  config.oauth_token_secret = ENV['access_token_secret']
  config.auth_method        = :oauth
end

# This will pull a sample of all tweets based on
# your Twitter account's Streaming API role.
TweetStream::Client.new.track do |status|
  # The status object is a special Hash with
  # method access to its keys.
  puts "#{status.text}"
end
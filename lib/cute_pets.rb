require './lib/cute_pets/pet_fetcher'
require './lib/cute_pets/tweet_generator'

module CutePets
  extend self

  def post_pet(zip, tweet_id)
    pet = PetFetcher.get_petfinder_pet(zip)
    if pet
      message = TweetGenerator.create_message(pet[:name], pet[:description], pet[:link])
      TweetGenerator.tweet(message, pet[:pic], tweet_id)
    end
  end
end
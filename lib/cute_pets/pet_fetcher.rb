require 'net/http'
require 'json'
require 'open-uri'
require 'hpricot'
require 'dotenv'
Dotenv.load

module PetFetcher
  extend self

  def get_petfinder_pet(zip)
    uri = URI('http://api.petfinder.com/pet.getRandom')
    params = {
      format:    'json',
      key:        ENV.fetch('petfinder_key'),
      shelterid:  get_shelter_id(zip),
      output:    'full'
    }
    uri.query = URI.encode_www_form(params)
    response = Net::HTTP.get_response(uri)

    if response.kind_of? Net::HTTPSuccess
      json = JSON.parse(response.body)
      pet_json  = json['petfinder']['pet']
      {
        pic:   get_photo(pet_json),
        link:  "https://www.petfinder.com/petdetail/#{pet_json['id']['$t']}",
        name:  pet_json['name']['$t'].capitalize,
        description: [get_petfinder_option(pet_json['options']), get_petfinder_sex(pet_json['sex']['$t']),  get_petfinder_breed(pet_json['breeds'])].compact.join(' ').downcase
      }
    else
      raise 'PetFinder api request failed'
    end
  end

private

  def get_petfinder_sex(sex_abbreviation)
    sex_abbreviation.downcase == 'f' ? 'female' : 'male'
  end

  PETFINDER_ADJECTIVES = {
    'housebroken' => 'house trained',
    'housetrained' => 'house trained',
    'noClaws'     => 'declawed',
    'altered'     => 'altered',
    'noDogs'      => nil,
    'noCats'      => nil,
    'noKids'      => nil,
    'hasShots'    => nil
  }.freeze

  def get_petfinder_option(option_hash)
    if option_hash['option']
      [option_hash['option']].flatten.map { |hsh| PETFINDER_ADJECTIVES[hsh['$t']] }.compact.first
    else
      option_hash['$t']
    end
  end

  def get_petfinder_breed(breeds)
    if breeds['breed'].is_a?(Array)
      "#{breeds['breed'].map(&:values).flatten.join('/')} mix"
    else
      breeds['breed']['$t']
    end
  end

  def self.get_photo(pet)
    if !pet['media']['photos']['photo'].nil?
      pet['media']['photos']['photo'][2]['$t']
    end
  end

  def get_shelter_id(zip)
    uri = URI('http://api.petfinder.com/shelter.find')
    params = {
      format:    'json',
      key:       ENV.fetch('petfinder_key'),
      location:  zip
    }
    uri.query = URI.encode_www_form(params)
    response = Net::HTTP.get_response(uri)

    if response.kind_of? Net::HTTPSuccess
      json = JSON.parse(response.body)
      shelters_json  = json['petfinder']['shelters']['shelter']
      shelters_json.each.map { |shelter| shelter['id']['$t'] }.sample
    else
      raise 'PetFinder api request failed'
    end
  end
end

# frozen_string_literal: true

require 'cards'
require 'cribbage'
require 'sinatra'
require 'sinatra/cross_origin'
require 'json'

register Sinatra::CrossOrigin

configure do
  enable :cross_origin
end

get '/' do
  'Hello world!'
end

get '/score' do
  card_defs = params['hand']
  return 0.to_s if card_defs.nil?
  hand = Cribbage::Hand.new(card_defs)
  hand.cut_card = create_card(params['cut']) unless params['cut'].nil?
  hand.is_crib = params['crib'].nil? ? false : params['crib'] == 'true'
  Cribbage::BasicScore.new(hand).total.to_s
end

get '/cards' do
  content_type :json
  cards = []
  Cards::Deck.new.tap do |deck|
    deck.cards.each do |card|
      card_hash = {
        name: card.name,
        suit: card.suit,
        fullName: card.to_s,
        image: [card.name.to_s, card.suit.to_s].join('-') + '.png',
        key: card.key
      }
      cards.push(card_hash)
    end
  end
  cards.to_json
end

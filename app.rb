# frozen_string_literal: true

require 'cards'
require 'cribbage'
require 'sinatra'

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

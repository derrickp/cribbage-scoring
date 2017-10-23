
# frozen_string_literal: true

require 'cards'
require 'cribbage'
def create_cards(card_defs)
  parts = card_defs.split(' ')
  parts.map { |part| create_card(part) }
end

# card_def is going to be a string of the format "2S" (for two of spades) or "AH" (for ace of hearts)
# This will parse the provided definition and return a card of the right type
def create_card(card_def)
  name_part = card_def[0].downcase
  suit_part = card_def[1].downcase

  name = nil
  suit = nil

  case name_part
  when 'a'
    name = :ace
  when '2'
    name = :two
  when '3'
    name = :three
  when '4'
    name = :four
  when '5'
    name = :five
  when '6'
    name = :six
  when '7'
    name = :seven
  when '8'
    name = :eight
  when '9'
    name = :nine
  when 't'
    name = :ten
  when 'j'
    name = :jack
  when 'q'
    name = :queen
  when 'k'
    name = :king
  end

  case suit_part
  when 'h'
    suit = :hearts
  when 'd'
    suit = :diamonds
  when 's'
    suit = :spades
  when 'c'
    suit = :clubs
  end

  Cards::Card.new(name, suit)
end

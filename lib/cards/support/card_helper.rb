
# frozen_string_literal: true

require 'cards'

def create_cards(card_defs)
  parts = card_defs.split(' ')
  parts.map { |part| create_card(part) }
end

# card_def is going to be a string of the format "2S" (for two of spades) or "AH" (for ace of hearts)
# This will parse the provided definition and return a card of the right type
def create_card(card_def)
  name_part = card_def[0].downcase
  suit_part = card_def[1].downcase

  name = get_name(name_part)
  suit = get_suit(suit_part)
  Cards::Card.new(name, suit)
end

def get_name_key(name)
  case name
  when :ace
    'A'
  when :two
    '2'
  when :three
    '3'
  when :four
    '4'
  when :five
    '5'
  when :six
    '6'
  when :seven
    '7'
  when :eight
    '8'
  when :nine
    '9'
  when :ten
    'T'
  when :jack
    'J'
  when :queen
    'Q'
  when :king
    'K'
  end
end

def get_suit_key(suit)
  case suit
  when :hearts
    'H'
  when :diamonds
    'D'
  when :spades
    'S'
  when :clubs
    'C'
  end
end

def get_name(name_part)
  case name_part
  when 'a'
    :ace
  when '2'
    :two
  when '3'
    :three
  when '4'
    :four
  when '5'
    :five
  when '6'
    :six
  when '7'
    :seven
  when '8'
    :eight
  when '9'
    :nine
  when 't'
    :ten
  when 'j'
    :jack
  when 'q'
    :queen
  when 'k'
    :king
  end
end

def get_suit(suit_part)
  case suit_part
  when 'h'
    :hearts
  when 'd'
    :diamonds
  when 's'
    :spades
  when 'c'
    :clubs
  end
end

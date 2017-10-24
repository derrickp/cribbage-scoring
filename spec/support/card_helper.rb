
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

  name =
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

  suit =
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

  Cards::Card.new(name, suit)
end

# frozen_string_literal: true

require 'cards'

module Cribbage
  # Model of a crib hand. Extends a hand of cards
  # But adds some extra information about if it is the crib
  # and what the current cut card is
  class Hand < Cards::Hand
    attr_accessor :cut_card
    attr_accessor :is_crib
  end
end

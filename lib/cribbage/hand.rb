
require "cards"

module Cribbage
  class Hand < Cards::Hand
    attr_accessor :cut_card
    attr_accessor :is_crib
  end
end
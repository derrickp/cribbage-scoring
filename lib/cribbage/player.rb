# frozen_string_literal: true

module Cribbage

  # Model of a single player of the game
  class Player
    attr_accessor :name
    attr_accessor :score
    attr_accessor :hand
    attr_accessor :crib

    def initialize(name)
      @name = name
    end
  end
end
# frozen_string_literal: true

require_relative 'basic_score'

module Cribbage
  # A scorer that doubles all scores and speeds up the game
  class DoubleScore < BasicScore
    def fifteens
      super * 2
    end

    def runs
      super * 2
    end

    def pairs
      super * 2
    end

    def total
      super * 2
    end

    def flushes
      super * 2
    end

    def nobs
      super * 2
    end
  end
end

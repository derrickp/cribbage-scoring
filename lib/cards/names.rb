
# frozen_string_literal: true

module Cards
  module Names
    ACE = :ace
    TWO = :two
    THREE = :three
    FOUR = :four
    FIVE = :five
    SIX = :six
    SEVEN = :seven
    EIGHT = :eight
    NINE = :nine
    TEN = :ten
    JACK = :jack
    QUEEN = :queen
    KING = :king
  end

  # A convenience for getting all of the names as an iterable
  ALL_NAMES = [
    Cards::Names::ACE,
    Cards::Names::TWO,
    Cards::Names::THREE,
    Cards::Names::FOUR,
    Cards::Names::FIVE,
    Cards::Names::SIX,
    Cards::Names::SEVEN,
    Cards::Names::EIGHT,
    Cards::Names::NINE,
    Cards::Names::TEN,
    Cards::Names::JACK,
    Cards::Names::QUEEN,
    Cards::Names::KING
  ].freeze
end

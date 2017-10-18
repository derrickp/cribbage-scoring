
module Cribbage
    class Card
        attr_accessor :suit
        attr_accessor :name
        def initialize(suit, name)
            @suit = suit
            @name = name
        end

        def to_s
            "#{self.name} of #{self.suit}"
        end
    end

    module CardNames
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

    module Suits
        HEARTS = :hearts
        SPADES = :spades
        CLUBS = :clubs
        DIAMONDS = :diamonds
    end
end
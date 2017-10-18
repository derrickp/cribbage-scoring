
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
end
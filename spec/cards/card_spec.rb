# frozen_string_literal: true

require 'spec_helper'

module Cards
  RSpec.describe Card do
    subject { Card.new(name, suit) }

    context 'basic card info' do
      let(:name) { :ace }
      let(:suit) { :spades }

      it 'should not be nil' do
        expect(subject).not_to be nil
      end

      it 'to_s should give full description' do
        full = subject.to_s.downcase
        suit_match = full[/hearts|clubs|spades|diamonds/]
        expect(suit_match).not_to be nil
        name_match = full[/ace|two|three|four|five|six|seven|eight|nine|ten|jack|queen|king/]
        expect(name_match).not_to be nil
      end
    end
  end
end

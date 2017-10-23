# frozen_string_literal: true

require 'spec_helper'
require_relative '../support/card_helper'

module Cards
  RSpec.describe Hand do
    subject { Hand.new }

    it 'is not nil after creation' do
      expect(subject).not_to be nil
    end

    context 'card addition' do
      let(:card) { create_card('AS') }
      
      context 'adding a single card' do
        before { subject.add_card(card) }
        
        it 'has a single card' do
          expect(subject.cards.length).to eq 1
        end
      end
    end
  end
end

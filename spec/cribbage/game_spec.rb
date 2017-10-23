# frozen_string_literal: true

require 'spec_helper'

module Cribbage

  RSpec.describe Game do
    let(:game) do
      return Game.new(num_players) unless num_players.nil?
      Game.new
    end
    subject { game }

    context 'default number of players' do
      let(:num_players) { nil }
      it 'number of players should be 2' do
        expect(subject.players.length).to eq 2
      end

      describe 'dealing' do
        context 'deals to all players' do
          before { game.deal }

          it 'all players should have 4 cards' do
            subject.players.each do |player|
              expect(player.hand.cards.length).to eq 4
            end
          end

          it 'dealer should have a crib' do
            dealer = subject.dealer
            expect(dealer).not_to be nil
            expect(dealer.crib).not_to be nil
          end
        end
      end

      describe 'scoring' do
        context 'scores all players' do
          before do
            game.deal
            game.score
          end

          it 'all players should have non-nil score' do
            subject.players.each do |player|
              expect(player.score).not_to be nil
            end
          end
        end
      end
    end

    context '3 players' do
      let(:num_players) { 3 }

      it 'number of players should be 3' do
        expect(subject.players.length).to eq 3
      end

      describe 'dealing' do
        context 'deals to all players' do
          before { game.deal }

          it 'all players should have 4 cards' do
            subject.players.each { |player| expect(player.hand.cards.length).to eq 4 }
          end
        end
      end

      describe 'scoring' do
        context 'scores all players' do
          before do
            game.deal
            game.score
          end

          it 'all players should have a non-nil score' do
            subject.players.each { |player| expect(player.score).not_to be nil }
          end
        end
      end
    end
  end
end

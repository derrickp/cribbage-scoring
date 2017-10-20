# frozen_string_literal: true

require 'spec_helper'

Card = Cards::Card

def create_card(card_def)
  parts = card_def.split(' ')
  Card.new(parts[0].to_sym, parts[1].to_sym)
end

def create_cards(card_defs)
  card_defs.map { |card_def| create_card(card_def) }
end

module Cribbage
  RSpec.describe Cribbage do
    it 'has a version number' do
      expect(VERSION).not_to be nil
    end
  end

  RSpec.describe Scoring do
    let(:hand) do
      Hand.new.tap do |hand|
        cards.each { |card| hand.add_card(card) }
        hand.cut_card = cut_card
        hand.is_crib = is_crib
      end
    end

    describe 'fifteens' do
      subject { Scoring.score_fifteens(hand) }
      let(:is_crib) { false }
      context 'single fifteen' do
        let(:cards) do
          create_cards(
            [
              'seven hearts',
              'eight spades',
              'six spades',
              'four diamonds'
            ]
          )
        end
        let(:cut_card) { create_card('ten hearts') }

        it 'should score 2' do
          expect(subject).to be 2
        end
      end

      context 'multiple fifteens (kings/queens/fives)' do
        let(:cards) do
          create_cards(
            [
              'five hearts',
              'ten hearts',
              'queen spades',
              'king spades'
            ]
          )
        end
        let(:cut_card) { create_card('nine diamonds') }

        it 'should score 6' do
          expect(subject).to be 6
        end
      end

      context 'multiple fifteens' do
        let(:cards) do
          create_cards(
            [
              'seven hearts',
              'eight spades',
              'six spades',
              'nine diamonds'
            ]
          )
        end
        let(:cut_card) { create_card('ten hearts') }

        it 'should score 4' do
          expect(subject).to be 4
        end
      end

      context 'three card fifteen' do
        let(:cards) do
          create_cards(
            [
              'two hearts',
              'nine spades',
              'queen spades',
              'four diamonds'
            ]
          )
        end
        let(:cut_card) { create_card('king hearts') }

        it 'should score 2' do
          expect(subject).to be 2
        end
      end

      context 'three 5s' do
        let(:cards) do
          create_cards(
            [
              'five hearts',
              'five spades',
              'five clubs',
              'two diamonds'
            ]
          )
        end
        let(:cut_card) { create_card('two hearts') }

        it 'should score 2' do
          expect(subject).to be 2
        end
      end

      context 'four card fifteen' do
        let(:cards) do
          create_cards(
            [
              'three hearts',
              'three spades',
              'five spades',
              'four diamonds'
            ]
          )
        end
        let(:cut_card) { create_card('ace hearts') }

        it 'should score 2' do
          expect(subject).to be 2
        end
      end

      context 'four fives' do
        let(:cards) do
          create_cards(
            [
              'five hearts',
              'five spades',
              'five clubs',
              'five diamonds'
            ]
          )
        end
        let(:cut_card) { create_card('ace hearts') }

        it 'should score 8' do
          expect(subject).to be 8
        end
      end

      context 'four fives w/ jack' do
        let(:cards) do
          create_cards(
            [
              'five hearts',
              'five spades',
              'five clubs',
              'five diamonds'
            ]
          )
        end
        let(:cut_card) { create_card('jack hearts') }

        it 'should be 16' do
          expect(subject).to be 16
        end
      end
    end

    describe 'pairs' do
      subject { Scoring.score_pairs(hand) }
      let(:is_crib) { false }
      context '1 pair' do
        let(:cards) do
          create_cards(
            [
              'two hearts',
              'two spapdes',
              'nine hearts',
              'king hearts'
            ]
          )
        end
        let(:cut_card) { create_card('five clubs') }

        it 'should score 2' do
          expect(subject).to be 2
        end
      end

      context '2 pairs' do
        let(:cards) do
          create_cards(
            [
              'two hearts',
              'two spades',
              'king hearts',
              'king spades'
            ]
          )
        end
        let(:cut_card) { create_card('five clubs') }

        it 'should score 4' do
          expect(subject).to be 4
        end
      end

      context '3 of a kind' do
        let(:cards) do
          create_cards(
            [
              'two hearts',
              'two spades',
              'two clubs',
              'king diamonds'
            ]
          )
        end
        let(:cut_card) { create_card('five clubs') }

        it 'should score 6' do
          expect(subject).to be 6
        end
      end

      context '4 of a kind' do
        let(:cards) do
          create_cards(
            [
              'two hearts',
              'two spades',
              'two clubs',
              'two diamonds'
            ]
          )
        end
        let(:cut_card) { create_card('five clubs') }

        it 'should score 12' do
          expect(subject).to be 12
        end
      end

      context '3 of a kind w/ cut card' do
        let(:cards) do
          create_cards(
            [
              'two hearts',
              'two spades',
              'two clubs',
              'king diamonds'
            ]
          )
        end
        let(:cut_card) { create_card('two diamonds') }

        it 'should score 12' do
          expect(subject).to be 12
        end
      end
    end

    describe 'nobs' do
      subject { Scoring.score_nobs(hand) }
      let(:cards) do
        create_cards(
          [
            'jack hearts',
            'jack spades',
            'queen hearts',
            'six hearts'
          ]
        )
      end
      let(:cut_card) { create_card('four hearts') }

      context 'hand is not crib' do
        let(:is_crib) { false }

        it 'should score 1' do
          expect(subject).to be 1
        end
      end

      context 'hand is crib' do
        let(:is_crib) { true }

        it 'should score 0' do
          expect(subject).to be 0
        end
      end

      context 'no cut card' do
        let(:is_crib) { false }
        let(:cut_card) { nil }

        it 'should score 0' do
          expect(subject).to be 0
        end
      end
    end

    describe 'flushes' do
      subject { Scoring.score_flush(hand) }
      describe 'hand is a flush' do
        let(:cards) do
          create_cards(
            [
              'jack hearts',
              'eight hearts',
              'queen hearts',
              'six hearts'
            ]
          )
        end

        context 'is not a crib' do
          let(:is_crib) { false }

          context 'does not match cut card' do
            let(:cut_card) { create_card('four spades') }

            it 'should score 4' do
              expect(subject).to be 4
            end
          end

          context 'does match cut card' do
            let(:cut_card) { create_card('four hearts') }

            it 'should score 5' do
              expect(subject).to be 5
            end
          end
        end

        context 'is a crib' do
          let(:is_crib) { true }

          context 'does not match cut card' do
            let(:cut_card) { create_card('four spades') }

            it 'should score 0' do
              expect(subject).to be 0
            end
          end

          context 'matches cut card' do
            let(:cut_card) { create_card('four hearts') }

            it 'should score 5' do
              expect(subject).to be 5
            end
          end
        end
      end
    end

    describe 'runs' do
      subject { Scoring.score_runs(hand) }
      let(:is_crib) { true }
      let(:cut_card) { create_card('nine hearts') }

      context '3-card run' do
        let(:cards) do
          create_cards(
            [
              'two hearts',
              'three spades',
              'four spades',
              'jack diamonds'
            ]
          )
        end

        it 'should score 3' do
          expect(subject).to be 3
        end
      end

      context '4-card run' do
        let(:cards) do
          create_cards(
            [
              'two hearts',
              'three spades',
              'four spades',
              'five diamonds'
            ]
          )
        end

        it 'should score 4' do
          expect(subject).to be 4
        end
      end

      context '5-card run' do
        let(:cards) do
          create_cards(
            [
              'two hearts',
              'three spades',
              'four spades',
              'five diamonds'
            ]
          )
        end
        let(:cut_card) { create_card('six hearts') }

        it 'should score 5' do
          expect(subject).to be 5
        end
      end

      context 'double 3-card run' do
        let(:cards) do
          create_cards(
            [
              'two spades',
              'three hearts',
              'four spades',
              'two diamonds'
            ]
          )
        end

        it 'should score 6' do
          expect(subject).to eq 6
        end
      end

      context 'triple 3-card run' do
        let(:cards) do
          create_cards(
            [
              'two spades',
              'three spades',
              'four hearts',
              'two diamonds'
            ]
          )
        end
        let(:cut_card) { create_card('two hearts') }

        it 'should score 9' do
          expect(subject).to eq 9
        end
      end

      context 'double-double 3-card run' do
        let(:cards) do
          create_cards(
            [
              'two hearts',
              'three spades',
              'three spades',
              'four diamonds'
            ]
          )
        end
        let(:cut_card) { create_card('four hearts') }

        it 'should score 12' do
          expect(subject).to eq 12
        end
      end
    end

    describe 'full hand' do
      subject { Scoring.score_hand(hand) }
      let(:is_crib) { false }

      context 'four fives w/ proper jack (best hand)' do
        let(:cards) do
          create_cards(
            [
              'jack hearts',
              'five spades',
              'five clubs',
              'five diamonds'
            ]
          )
        end
        let(:cut_card) { create_card('five hearts') }

        it 'should score 29' do
          expect(subject).to eq 29
        end
      end

      context 'single run, 3 fifteens' do
        let(:cards) do
          create_cards(
            [
              'jack hearts',
              'queen spades',
              'king clubs',
              'five diamonds'
            ]
          )
        end
        let(:cut_card) { create_card('nine diamonds') }

        it 'should score 9' do
          expect(subject).to eq 9
        end
      end

      context 'single run, 2 fifteens, no nobs because of crib' do
        let(:is_crib) { true }
        let(:cards) do
          create_cards(
            [
              'jack hearts',
              'nine spades',
              'ten clubs',
              'five diamonds'
            ]
          )
        end
        let(:cut_card) { create_card('four hearts') }

        it 'should score 7' do
          expect(subject).to eq 7
        end
      end
    end
  end

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

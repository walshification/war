require_relative 'test_helper'

require_relative '../lib/game'
require_relative '../lib/card'
require_relative '../lib/player_hand'

describe Game do
  describe '#initialize' do
    it 'defaults to a deck of 52 cards' do
      game = Game.new
      assert_equal(game.deck.cards.count, 52)
    end
  end

  describe '#deal' do
    before do
      @deck = Deck.new(['card 1', 'card 2'])
      @player_one = PlayerHand.new
      @player_two = PlayerHand.new
      @game = Game.new(@player_one, @player_two, @deck)
    end

    it 'passes cards in the deck to each player' do
      def mock_shuffle; end
      @deck.cards.stub :shuffle!, mock_shuffle do # don't shuffle in this test
        @game.deal
        assert_equal(@player_one.cards, ['card 2'])
        assert_equal(@player_two.cards, ['card 1'])
      end
    end
  end

  describe '#play_hand' do
    it 'passes losing card to player one when player one wins' do
      losing_card = Card.new(1)
      winning_card = Card.new(2)
      player_one = PlayerHand.new
      player_one.add(winning_card)
      player_two = PlayerHand.new
      player_two.add(losing_card)
      game = Game.new(player_one, player_two)

      game.play_hand
      assert_includes(player_one.cards, losing_card)
    end

    it 'passes losing card to player two when player two wins' do
      losing_card = Card.new(1)
      winning_card = Card.new(2)
      player_one = PlayerHand.new
      player_one.add(losing_card)
      player_two = PlayerHand.new
      player_two.add(winning_card)
      game = Game.new(player_one, player_two)

      game.play_hand
      assert_includes(player_two.cards, losing_card)
    end

    it 'passes the next three cards plus the tie to the winner of a war' do
      war_one = Card.new(1)
      war_two = Card.new(1)

      prize_pot_one = (1..3).map { |i| Card.new(i) }
      prize_pot_two = (4..6).map { |i| Card.new(i) }

      losing_card = Card.new(1)
      winning_card = Card.new(2)

      player_one = PlayerHand.new
      # ensure card order is:
      #   first card: the initial tie
      #   next three: prize pot
      #   last card: the winning one
      player_one.add(winning_card)
      prize_pot_one.each { |card| player_one.add(card) }
      player_one.add(war_one)

      player_two = PlayerHand.new
      player_two.add(losing_card)
      prize_pot_two.each { |card| player_two.add(card) }
      player_two.add(war_two)

      game = Game.new(player_one, player_two)

      game.play_hand
      prize_pot_two.all? { |prize_card| assert_includes(player_one.cards, prize_card) }
    end

    it 'can handle two or more wars in a row' do
      war_one = Card.new(1)
      war_two = Card.new(1)

      prize_pot_one = (1..3).map { |i| Card.new(i) }
      prize_pot_two = (4..6).map { |i| Card.new(i) }

      second_war_one = Card.new(1)
      second_war_two = Card.new(1)

      second_prize_pot_one = (1..3).map { |i| Card.new(i) }
      second_prize_pot_two = (7..9).map { |i| Card.new(i) }

      losing_card = Card.new(1)
      winning_card = Card.new(2)

      player_one = PlayerHand.new
      player_one.add(winning_card)
      second_prize_pot_one.each { |card| player_one.add(card) }
      player_one.add(second_war_one)
      prize_pot_one.each { |card| player_one.add(card) }
      player_one.add(war_one)

      player_two = PlayerHand.new
      player_two.add(losing_card)
      second_prize_pot_two.each { |card| player_two.add(card) }
      player_two.add(second_war_two)
      prize_pot_two.each { |card| player_two.add(card) }
      player_two.add(war_two)

      game = Game.new(player_one, player_two)

      game.play_hand
      (prize_pot_two + second_prize_pot_two).all? do |prize_card|
        assert_includes(player_one.cards, prize_card)
      end
    end
  end

  describe '#play' do
    it 'playes out two player hands until there is a winner' do
      deck = Deck.new([Card.new(1), Card.new(2)]) # simplest game
      def mock_shuffle; end
      deck.cards.stub :shuffle!, mock_shuffle do # don't shuffle in this test
        game = Game.new(nil, nil, deck)
        game.play
        assert_equal(game.winner, 'PLAYER ONE')
      end
    end
  end
end

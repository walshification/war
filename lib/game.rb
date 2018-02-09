$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'card'
require 'deck'
require 'player_hand'

class Game
  attr_reader :deck, :winner

  def initialize(player_one_hand = nil, player_two_hand = nil, deck = nil)
    @player_one_hand = player_one_hand || PlayerHand.new
    @player_two_hand = player_two_hand || PlayerHand.new
    @deck = deck || Deck.new(all_the_cards)
    @winner = nil
  end

  def play
    deal
    while unfinished?
      play_hand
    end
    @winner = @player_one_hand.has_cards? ? 'PLAYER ONE' : 'PLAYER TWO'
  end

  def deal
    @deck.deal_out(@player_one_hand, @player_two_hand)
  end

  def play_hand(pot = nil)
    if player_one_wins?
      pass_cards(@player_one_hand, @player_two_hand, pot)
    elsif player_two_wins?
      pass_cards(@player_two_hand, @player_one_hand, pot)
    else
      war(pot)
    end
  end

  private

  def all_the_cards
    cards = []
    4.times do |_|
      (2..14).each do |i|
        cards << Card.new(i)
      end
    end
    cards
  end

  def unfinished?
    @player_one_hand.has_cards? && @player_two_hand.has_cards?
  end

  def player_one_wins?
    @player_one_hand.current_card.value > @player_two_hand.current_card.value
  end

  def player_two_wins?
    @player_one_hand.current_card.value < @player_two_hand.current_card.value
  end

  def war(pot = nil)
    pot ||= []
    # cache the cards responsible for the war and the prize cards to the pot
    4.times do |_|
      pot << @player_one_hand.pass_current_card
      pot << @player_two_hand.pass_current_card
    end
    play_hand(pot)
  end

  def pass_cards(winner, loser, pot = nil)
    pot.each { |prize_card| winner.claim(prize_card) } unless pot.nil?
    winner.claim(loser.pass_current_card)
  end
end

# :nocov:
if __FILE__ == $0
  game = Game.new
  game.play
  puts "THE WINNER IS #{game.winner}"
end
# :nocov:

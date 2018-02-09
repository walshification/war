$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'card'
require 'deck'
require 'player_hand'

class Game
  def initialize
    @deck = Deck.new(all_the_cards)
    @player_one_hand = PlayerHand.new
    @player_two_hand = PlayerHand.new
  end

  def play
    deal
    while unfinished?
      play_hand
    end
    if @player_one_hand.has_cards?
      puts 'THE WINNER IS PLAYER ONE!'
    else
      puts 'THE WINNER IS PLAYER TWO!'
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
    cards.compact
  end

  def deal
    @deck.deal_out(@player_one_hand, @player_two_hand)
  end

  def unfinished?
    @player_one_hand.has_cards? && @player_two_hand.has_cards?
  end

  def play_hand(pot = nil)
    if player_one_wins?
      @player_one_hand.claim(@player_two_hand.pass_current_card)
    elsif player_two_wins?
      @player_two_hand.claim(@player_one_hand.pass_current_card)
    else
      war(pot)
    end
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
      pot << pass_card(@player_one_hand)
      pot << pass_card(@player_two_hand)
    end
    play_hand(pot)
  end

  def pass_card(hand)
    hand.pass_current_card
  end
end

if __FILE__ == $0
  Game.new.play
end

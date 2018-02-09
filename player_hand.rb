class PlayerHand
  def initialize
    @cards = []
    @current_card = nil
  end

  def cards
    @cards
  end

  def add(card)
    @cards << card
  end

  def has_cards?
    @cards.count > 0
  end

  def current_card
    @current_card ||= @cards.pop
  end

  def claim(card)
    @cards.unshift(card)
  end

  def pass_current_card
    card_to_pass = current_card
    @current_card = nil
    card_to_pass
  end
end

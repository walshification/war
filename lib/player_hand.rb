class PlayerHand
  def initialize
    @cards = []
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
    @cards.last
  end

  def claim(card)
    @cards.unshift(card)
  end

  def pass_current_card
    @cards.pop
  end
end

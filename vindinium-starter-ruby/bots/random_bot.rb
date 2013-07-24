class RandomBot < BaseBot

  def move state
    game = Game.new state
    DIRECTIONS.sample
  end

end


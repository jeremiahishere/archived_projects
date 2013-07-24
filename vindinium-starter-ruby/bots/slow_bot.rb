class SlowBot < BaseBot

  def move state
    sleep 2
    DIRECTIONS.sample
  end

end


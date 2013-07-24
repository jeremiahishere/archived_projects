class Hero

  attr_accessor :name, :pos, :life, :gold, :x, :y

  def initialize hero
    self.name = hero['name']
    self.pos = hero['pos']
    self.life = hero['life']
    self.gold = hero['gold']
    self.x = self.pos['x']
    self.y = self.pos['y']
  end

end

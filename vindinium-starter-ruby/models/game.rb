class Game

  attr_accessor :state, :board, :heroes, :mines_locs, :heroes_locs, :taverns_locs

  def initialize state
 
    self.state = state
    puts "Turn #{state['game']['turn'] / 4}"
    self.board = Board.new state['game']['board']
    self.mines_locs = {}
    self.heroes_locs = {}
    self.taverns_locs = []
    self.heroes = []

    state['game']['heroes'].each do |hero|
      self.heroes << Hero.new(hero)
    end

    self.board.tiles.each_with_index do |row, row_idx|

      row.each_with_index do |col, col_idx|
        # what kinda tile?
        obj = col 
        if obj.is_a? MineTile
          self.mines_locs[[row_idx, col_idx]] = obj.hero_id
        elsif obj.is_a? HeroTile
          self.heroes_locs[[row_idx, col_idx]] = obj.hero_tile_id
        elsif obj == TAVERN
          self.taverns_locs << [row_idx, col_idx]
        end

      end

    end

  end

end

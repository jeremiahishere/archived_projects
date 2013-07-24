class Board

  attr_accessor :size, :tiles

  def initialize board
    self.size = board['size']
    self.tiles = self.parse_tiles(board['tiles'])
  end

  def parse_tile str

    case str
    when '  '
      print '.. '
      AIR
    when '##'
      print "#{str} "
      WALL
    when '[]'
      print "#{str} "
      TAVERN
    when /\$([-0-9])/
      print "#{str} "
      MineTile.new($1)
    when /\@([-0-9])/
      print "#{str} "
      HeroTile.new($1)
    else
      puts "#{str} -- I have no idea what to do with that."
    end

  end

  def parse_tiles tiles

    vector = []
    matrix = []
    (0..tiles.length - 1).step(2).each do |i|
      puts if i % (self.size * 2) == 0 && i != 0
      this_vector = tiles[i..i+1]
      vector << self.parse_tile(this_vector)
    end
    (0..vector.length - 1).step(self.size).each do |i|
      this_matrix = vector[i..i+self.size-1]
      matrix << this_matrix
    end

    puts
    matrix

  end

  def passable? loc
    x, y = loc
    pos = self.tiles[x][y]
    (pos != WALL) and (pos != TAVERN) and (!pos.is_a?(MineTile))
  end

  def to loc, direction

    # calculate a new location given the direction
    row, col = loc
    d_row, d_col = AIM[direction]
    n_row = row + d_row
    n_row = 0 if n_row < 0
    n_row = self.size - 1 if n_row >= self.size
    n_col = col + d_col
    n_col = 0 if n_col < 0
    n_col = self.size - 1 if n_col >= self.size

    [n_row, n_col]

  end

end

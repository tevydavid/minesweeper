require 'byebug'

class Tile

  attr_reader :pos, :mined, :flagged, :revealed, :neighbor_mines

  attr_accessor :mined

  def initialize(board, pos)
    @board = board
    @pos = pos
    @mined = false
    @flagged = false
    @revealed = false
  end

  def reveal!
    return if @revealed || @flagged
    @revealed = true
    return if @neighbor_mines > 0
    self.neighbors.each {|tile| tile.reveal!}
  end

  def flag!
    @flagged = true
  end


  def inspect
    "mined? :#{@mined}, flagged: #{@flagged}, revealed: #{@revealed}, neighbor_mines: #{@neighbor_mines}"
  end

  def neighbors
    neighbor_positions = []
    (-1..1).each do |row|
      (-1..1).each do |col|
        next if row ==0 && col == 0
         possible_position = [@pos[0] + row, @pos[1] + col]
         neighbor_positions << possible_position if valid?(possible_position)
       end
     end
     neighbor_positions.map {|position| @board.[](position)}
  end

  def valid?(position)
    position[0].between?(0, 8) && position[1].between?(0, 8)
  end

  def count_neighbor_mines
    @neighbor_mines = 0
    self.neighbors.each do |neighbor_tile|
      @neighbor_mines += 1 if neighbor_tile.mined
    end
    return @neighbor_mines
  end

  def to_s
    if revealed && neighbor_mines < 1
      "_"
    elsif revealed
      "#{neighbor_mines}"
    elsif flagged
      "f"
    else
      "*"
    end
  end

end

class Board
  attr_reader :grid

  def initialize
    @grid = Array.new(9) {Array.new(9)}
    self.populate!
  end

  def render

  end



  def populate!(n = 10)
    @grid.each_with_index do |row, row_num|
      row.each_index do |col_num|
        @grid[row_num][col_num] = Tile.new(self, [row_num, col_num])
      end
    end
    bury_mines!(n)
    meet_the_neighbors
  end

  def meet_the_neighbors
    @grid.each do |row|
      row.each do |tile|
        tile.count_neighbor_mines
      end
    end
  end

  def bury_mines!(n = 10)
    mines = 0
    until mines == n
      tile = @grid.sample.sample
      unless tile.mined
        tile.mined = true
        mines +=1
      end
    end
  end

  def [](pos)
    row, col = pos
    @grid[row][col]

  end

end

class Game
  attr_reader :board
  def initialize
    @board = Board.new

  end

  def play
    until won?
      display
      take_turn
    end
    return "You survived!"
  end

  def display
    board.render
  end

  def get_input
  end

  def take_turn
    ##input
    over?
    if flagged
      puts "This spot is flagged. Are you sure you want to reveal it?"
      ##input
    reveal
  end
  end

  def over?

  end

  def won?

  end



end

if $PROGRAM_NAME == __FILE__

  game = Game.new
  game.board.grid.each do |row|
    row.each do |tile|
      print "[#{tile}]"
    end
    puts
  end

game.board.grid[2][2].reveal!
 puts "new board:"
 game.board.grid.each do |row|
   row.each do |tile|
     print "[#{tile}]"
   end
   puts
 end




end

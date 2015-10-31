require 'byebug'
require 'colorize'

class Tile

  attr_reader :pos, :mined, :revealed, :neighbor_mines

  attr_accessor :mined, :flagged

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
     neighbor_positions.map {|position| @board[position]}
  end

  def valid?(position)
    position[0].between?(0, 8) && position[1].between?(0, 8)
  end

  def count_neighbor_mines
    # @neighbor_mines = 0
    # self.neighbors.each do |neighbor_tile|
    #   @neighbor_mines += 1 if neighbor_tile.mined
    # end
    # return @neighbor_mines
    @neighbor_mines = self.neighbors.count{ |neighbor_tile| neighbor_tile.mined }
  end

  def to_s
    if revealed && mined
    "0".colorize(:red)
    elsif revealed && neighbor_mines < 1
      " ".colorize(:green)
    elsif revealed
      "#{neighbor_mines}".colorize (:blue)
    elsif flagged
      "f".colorize (:red)
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
    puts header
    @grid.each_with_index do |row, idx|
      print "#{idx} "
      row.each do |tile|
        print "[#{tile}]"
      end
      puts
    end
  end

  def header
    "   0  1  2  3  4  5  6  7  8"
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
      if over?
        board.grid.flatten.select(&:mined).each(&:reveal!)
        display
        puts "You Lose!! (a leg)".colorize(:red)
        return
      end
    end
    board.grid.flatten.each(&:reveal!)
    display
    puts "You survived!"
  end

  def display
    system("clear")
    board.render
  end

  def get_input
    print "Enter R for reveal or F for flag >> "
    @action = gets.chomp.upcase
    print "Enter Row, Column >> "
    @pos = gets.chomp.split(",").map(&:to_i)
  end

  def take_turn
    get_input
    tile_in_question = @board.[](@pos)
    if @action == "F"
      tile_in_question.flag!
      return
    elsif @action == "SAVE"
      save_game
    elsif @action == "LOAD"
      load_game
    elsif tile_in_question.flagged
      puts "This spot is flagged. Are you sure you want to reveal it?"
      print "Y/N >> "
      return if gets.chomp.upcase == "N"
      tile_in_question.flagged = false
    end
    tile_in_question.reveal!
  end

  def save_game

  end

  def load_game

  end



  def over?
    @board.[](@pos).mined && @board.[](@pos).revealed
  end

  def won?
    all_tiles = @board.grid.flatten
    total_tiles = all_tiles.count
    revealed_tiles = all_tiles.count(&:revealed)
    mine_tiles = all_tiles.count(&:mined)
    total_tiles == revealed_tiles + mine_tiles
  end



end

if $PROGRAM_NAME == __FILE__

  game = Game.new
  game.play
#   game.board.grid.each do |row|
#     row.each do |tile|
#       print "[#{tile}]"
#     end
#     puts
#   end
#
# game.board.grid[2][2].reveal!
#  puts "new board:"
#  game.board.grid.each do |row|
#    row.each do |tile|
#      print "[#{tile}]"
#    end
#    puts
#  end




end

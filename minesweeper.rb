class Tile

  attr_reader :pos, :bombed, :flagged, :revealed, :neighbor_bomb_count

  def initialize(board, pos, bombed = false)
    @board = board
    @pos = pos
    @bombed = bombed
    @flagged = false
    @revealed = false
  end

  def reveal!
    @revealed = true
  end

  def flag!
    @flagged = true
  end


  def inspect
    "bombed? :#{@bombed}, flagged: #{@flagged}, revealed: #{@revealed}, neighbor_bomb_count: #{@neighbor_bomb_count}"
  end

  def neighbors
    neighbor_positions = []
    (-1..1).each do |row|
      (-1..1).each do |col|
        next if row ==0 && col == 0
         possible_position = [@pos[0] + row, @pos[1] + col]
         neighbor_positions << possible_position if valid?(possible_position)
  end

  def valid?(position)
    position[0].between?(0, 8) && position[1].between?(0, 8)
  end



  def neighbor_bomb_count
    @neighbor_bomb_count
  end


end

class Board
  attr_reader :board

  def initialize


        #call each tile.neighbors
  end

end

class Game
  def initiali

  end

  def play

  end

  def display
  end

  def take_turn
  end

  def get_input
  end
end

if $PROGRAM_NAME == __FILE__
  game = Game.new
  game.play
end

class Tile
  def initialize(board)
    @board = board
    @value =
  end

  def reveal!
  end



  def inspect
  end

  def neighbors
  end

  def neighbor_bomb_count
  end


end

class Board

end

class Game
  def initialize

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

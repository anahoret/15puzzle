require 'enumerator'

class Puzzle

  def initialize
    @board = (1..15).to_a << 0
  end

  def board
    @board.enum_slice(4).to_a
  end

  def solved?
    @board.eql?((1..15).to_a << 0) 
  end

  def shuffle!
    @board = @board.sort_by{ rand }
  end
  
  def movable? square
    return unless @board.include?(square) && square != 0
    (find_row square) == (find_row 0) || (find_col square) == (find_col 0)
  end 

  def move square
    return unless movable? square
    
    if find_row(square) == find_row(0)
      move_in_row(@board, square)
    else
      transposed_board = board.transpose
      move_in_row(transposed_board[find_col(square)], square)
      @board = transposed_board.transpose.flatten
    end
  end
  
private

  def find_row square
    @board.index(square) / 4
  end

  def find_col square
    @board.index(square) - find_row(square) * 4
  end
  
  def move_in_row row, square
    from, to = row.index(square), row.index(0)
    row.delete_at(to)
    row.insert(from, 0)
  end

end
require 'enumerator'

class Puzzle

  def initialize
    @board = (1..15).to_a << 0
  end

  def board
    @board.enum_slice(4).to_a
  end

  def solved?
    @board.eql?((1..15).to_a << 0) || @board.eql?((1..13).to_a << 15 << 14 << 0)
  end

  def shuffle!
    @board = (0..15).sort_by{ rand }
  end
  
  def movable? square
    return unless @board.include?(square) && square != 0
    (find_row square) == (find_row 0) || (find_col square) == (find_col 0)
  end 

  def move square
    return unless movable? square
    
    from_row, to_row = find_row(square), find_row(0)
    from_col, to_col = find_col(square), find_col(0)
    if from_row == to_row
      move_in_row(@board, square)
    else
      transposed_board = board.transpose
      move_in_row(transposed_board[from_col], square)
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
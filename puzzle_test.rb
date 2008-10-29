require 'puzzle'
require 'test/unit'

class PuzzleTest < Test::Unit::TestCase
  
  def setup
    @puzzle = Puzzle.new
  end
  
  def test_new_puzzle_is_solved
    expected = (1..15).map << 0
    assert_equal expected, @puzzle.board.flatten
    assert @puzzle.solved?
  end
  
  def test_shuffle
    @puzzle.shuffle!
    assert !@puzzle.solved?
  end
  
  def test_vertical_move
    @puzzle.move 8
    assert_equal [ [  1,  2,  3,  4, ],
                   [  5,  6,  7,  0, ],
                   [  9, 10, 11,  8, ],
                   [ 13, 14, 15, 12  ] ], @puzzle.board
                   
    @puzzle.move 12
    assert_equal [ [  1,  2,  3,  4, ],
                   [  5,  6,  7,  8, ],
                   [  9, 10, 11, 12, ],
                   [ 13, 14, 15,  0  ] ], @puzzle.board
  end
  
  
  def test_gorizontal_move
    @puzzle.move 14
    assert_equal [ [  1,  2,  3,  4, ],
                   [  5,  6,  7,  8, ],
                   [  9, 10, 11, 12, ],
                   [ 13,  0, 14, 15  ] ], @puzzle.board
                   
    @puzzle.move 15
    assert_equal [ [  1,  2,  3,  4, ],
                   [  5,  6,  7,  8, ],
                   [  9, 10, 11, 12, ],
                   [ 13, 14, 15,  0  ] ], @puzzle.board
  end
  
  def test_is_movable
    assert  (@puzzle.movable? 8)
    assert  (@puzzle.movable? 15)
    assert !(@puzzle.movable? 10)
    assert !(@puzzle.movable? 0)
    assert !(@puzzle.movable? 16)

    @puzzle.move 8
    assert (@puzzle.movable? 12)
  end
    
private
  def print_board board
    puts
    board.each {|row| row.each { |n| printf '[%3s ]', (n.zero? ? '' : n) }; puts "\n" }
  end

end
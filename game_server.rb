require 'microrails'
require 'puzzle'

session("key", "secret" * 15)

routes do
  root :controller => 'game'
  move '/move/:id', :controller => 'game', :action => 'move'
end

controller "game" do
  def index
    @puzzle = Puzzle.new
    @puzzle.shuffle!
    session[:puzzle] = @puzzle
  end
  
  def move
    @puzzle = find_game
    @puzzle.move params[:id].to_i if @puzzle.movable? params[:id].to_i
    session[:puzzle] = @puzzle
  end

private

  def find_game
    session[:puzzle]
  end
end

start "0.0.0.0", "3000"
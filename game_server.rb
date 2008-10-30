require 'microrails'
require 'puzzle'

session("key", "secret" * 15)

routes do
  root :controller => 'game'
  move '/move/:id', :controller => 'game', :action => 'move'
end

controller "game" do
  
  def index
    flash[:notice] = 'You have started new game!'
    @puzzle = Puzzle.new
    @puzzle.shuffle!
    session[:puzzle] = @puzzle
    render :action => 'move'
  end
  
  def move
    @puzzle = session[:puzzle]
    square = params[:id].to_i
    
    if @puzzle.movable? square
      @puzzle.move square
      session[:puzzle] = @puzzle
      flash[:notice] = 'Puzzle is solved. Congratulation!' if @puzzle.solved?
    else
      flash[:error] = 'Wrong move!'
    end
    
  end

end

start "0.0.0.0", "3000"
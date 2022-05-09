class BoardsController < ApplicationController
  def index
    @boards = Board.all
  end

  def show
    @board = Board.find(params[:id])
  end

  def new
    @board = Board.new
  end

  def create
    @board = Create.new(board_params).call
    redirect_to boards_path
    rescue ActiveRecord::RecordInvalid => invalid
      @board = invalid.record
      render :new
  end

  def destroy
    @board = Board.find(params[:id])
    @board.destroy

    redirect_to root_path, status: :see_other
  end


  private
    def board_params
      params.require(:board).permit(:name)
    end
end

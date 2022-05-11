class Board < ApplicationRecord
  has_many :fields, dependent: :destroy
  validates :name, presence: true


  def get_field_value(row_index, column_index)
    @board[row_index][column_index].value
  end


  def set_field_value(value, row_index, column_index)
    @board[row_index][column_index].value = value
  end


  def solve
    @board = Array.new(9){Array.new(9){1}}
    solve_board
  end

  def set_field(field, row_index, column_index)
    @board[row_index][column_index] = field
  end

  private

  def save_board(sudoku_board)
    puts sudoku_board
  end


  def find_empty_field
    0.upto 8 do |row|
      0.upto 8  do |column|
        if @board[row][column].eql? 0
          return [row, column]  # return row and column indexes if an empty field was found
        end
      end
    end
    false  # return false if there are no more empty fields
  end


  def safe?(number, row, column)  # method checks if a given number can be inserted into given field
    0.upto 8 do |i|
      if @board[row][i].eql? number
        return false
      end

      if @board[i][column].eql? number
        return false
      end
    end

    row_start = row - row % 3
    column_start = column- column % 3

    row_start.upto(row_start + 3) do |i|
      column_start.upto(column_start + 3) do |j|
        if @board[i][j].eql? number
          return false
        end
      end
    end
  end


  def solve_board
    found_field = find_empty_field
    if found_field.eql? false
      save_board(@board)
      return true  # if there are no empty fields, sudoku is solved
    end

    row = found_field[0]
    column = found_field[1]

    9.times do
      number = rand 1..9
      if safe?(number, row, column)
        @board[row][column] = number

        if solve
          return true
        end

        @board[row][column] = 0
        number += 1
        if number.eql? 10
          number = 1
        end
      end
    end
    false
  end

end

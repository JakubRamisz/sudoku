class Board < ApplicationRecord
  has_many :fields, dependent: :destroy
  validates :name, presence: true

  after_create do
    @board = Array.new(9){Array.new(9){0}}
    solve
  end

  private

  def save_board
    0.upto 8 do |row|
      0.upto 8 do |column|
        fields.create(value: @board[row][column], row: row, column: column)
      end
    end
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

    row_start.upto(row_start + 2) do |i|
      column_start.upto(column_start + 2) do |j|
        if @board[i][j].eql? number
          return false
        end
      end
    end
    true
  end


  def solve
    found_field = find_empty_field  # find the first empty field

    if found_field.eql? false  # if there are no empty fields, sudoku is solved
      save_board
      return true
    end

    row = found_field[0]
    column = found_field[1]

    9.times do  # try setting the empty field to numbers 1-9
      number = rand 1..9
      if safe?(number, row, column)
        @board[row][column] = number

        if solve  # recursive call
          return true
        else  # if recursive solve call returned false, set field to 0 and increment the number
          @board[row][column] = 0
          number += 1
          if number.eql? 10
            number = 1
          end
        end
      end
    end
    false  # return false if none of the numbers fit in this field
  end

end

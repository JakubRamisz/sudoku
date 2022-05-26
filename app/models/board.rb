class Board < ApplicationRecord
  has_many :fields, dependent: :destroy
  validates :name, presence: true

  after_create do
    @board = Array.new(9){Array.new(9){0}}
    solve
    clear_fields(30)
  end

  def clear_fields(number_of_fields)
    # sets values of given number of random fields to 0 and their editable attributes to true
    while number_of_fields > 0 do
      row = rand 0..8
      column = rand 0..8
      unless fields.find_by(row: row, column: column).editable
        fields.find_by(row: row, column: column).update(editable: true)
        fields.find_by(row: row, column: column).update(value: 0)
        number_of_fields -= 1
      end
    end
  end


  def solved?
    # returns false if any number from 1 to 9 appears more or less than once in any row, column or square,
    # otherwise returns true
    1.upto 9 do |number|
      0.upto 8 do |i|
        unless fields.where(row: i, value: number).size.eql?(1)
          return false
        end

        unless fields.where(column: i, value: number).size.eql?(1)
          return false
        end
      end

      0.upto 2 do |i|
        0.upto 2 do |j|
          unless fields.where(row: 3*i..3*i+2, column: 3*j..3*j+2, value: number).size.eql?(1)
            return false
          end
        end
      end
    end

    true
  end

  private

  def save_board
    0.upto 8 do |row|
      0.upto 8 do |column|
        fields.create(value: @board[row][column], row: row, column: column, editable: false)
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


  def safe?(number, row, column)  # checks if a given number can be inserted into given field
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

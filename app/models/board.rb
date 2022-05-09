class Board < ApplicationRecord
  has_many :fields, dependent: :destroy
  validates :name, presence: true

  def safe?(number, row_index, column_index)  # method checks if a given number can be inserted into given field
    row = fields.where(row: row_index)
    row.each do |field|
      if field.value.eql?(number)
        return false
      end
    end

    column = fields.where(column: column_index)
    column.each do |field|
      if field.value.eql?(number)
        return false
      end
    end

    row_start = row_index - row_index % 3
    column_start = column_index - column_index % 3

    box = fields.where(row: [row_start, row_start + 1, row_start + 2],
                       column: [column_start, column_start + 1, column_start + 2])
    box.each do |field|
      if field.value.eql?(number)
        return false
      end
    end
  end

  def find_empty_field
    0.upto 8 do |row_index|
      0.upto 8  do |column_index|
        if fields.where(row: row_index, column: column_index).value.eql?(0)
          return [true, row_index, column_index]  # return true if an empty field was found
        end
      end
    end
    false  # return false if there are no more empty fields
  end
end
